# This is a bit of a hackish way of getting around the ownership restrictions
# placed on @transferPropsTo. The best approach moving forward will likely be
# to use cloneWithProps (https://github.com/facebook/react/commits/master/src/
# utils/cloneWithProps.js), but it's in 0.9.0.alpha and is not currently
# exposes via the public API.
module.exports = React.createClass

  render: ->
    @transferPropsTo @props.renderComponent()
