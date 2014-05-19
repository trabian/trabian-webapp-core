'use strict'

# Copyright (C) 2012 Moviepilot GmbH
# http://moviepilot.com/contact
# With contributions by several individuals:
# https://github.com/chaplinjs/chaplin/graphs/contributors

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Simple finite state machine for synchronization of models/collections
# Three states: unsynced, syncing and synced
# Several transitions between them
# Fires Backbone events on every transition
# (unsynced, syncing, synced; syncStateChange)
# Provides shortcut methods to call handlers when a given state is reached
# (named after the events above)

UNSYNCED = 'unsynced'
SYNCING  = 'syncing'
SYNCED   = 'synced'

STATE_CHANGE = 'syncStateChange'

SyncMachine =
  _syncState: UNSYNCED
  _previousSyncState: null

  # Get the current state
  # ---------------------

  syncState: ->
    @_syncState

  isUnsynced: ->
    @_syncState is UNSYNCED

  isSynced: ->
    @_syncState is SYNCED

  isSyncing: ->
    @_syncState is SYNCING

  # Transitions
  # -----------

  unsync: ->
    if @_syncState in [SYNCING, SYNCED]
      @_previousSync = @_syncState
      @_syncState = UNSYNCED
      @trigger @_syncState, this, @_syncState
      @trigger STATE_CHANGE, this, @_syncState
    # when UNSYNCED do nothing
    return

  beginSync: ->
    if @_syncState in [UNSYNCED, SYNCED]
      @_previousSync = @_syncState
      @_syncState = SYNCING
      @trigger @_syncState, this, @_syncState
      @trigger STATE_CHANGE, this, @_syncState
    # when SYNCING do nothing
    return

  finishSync: ->
    if @_syncState is SYNCING
      @_previousSync = @_syncState
      @_syncState = SYNCED
      @trigger @_syncState, this, @_syncState
      @trigger STATE_CHANGE, this, @_syncState
    # when SYNCED, UNSYNCED do nothing
    return

  abortSync: ->
    if @_syncState is SYNCING
      @_syncState = @_previousSync
      @_previousSync = @_syncState
      @trigger @_syncState, this, @_syncState
      @trigger STATE_CHANGE, this, @_syncState
    # when UNSYNCED, SYNCED do nothing
    return

# Create shortcut methods to bind a handler to a state change
# -----------------------------------------------------------

for event in [UNSYNCED, SYNCING, SYNCED, STATE_CHANGE]
  do (event) ->
    SyncMachine[event] = (callback, context = this) ->
      @on event, callback, context
      callback.call(context) if @_syncState is event

# You’re frozen when your heart’s not open.
Object.freeze? SyncMachine

# Return our creation.
module.exports = SyncMachine
