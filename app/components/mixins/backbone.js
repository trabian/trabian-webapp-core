module.exports = {
    _subscribe: function(model) {
        if (!model) {
            return;
        }
        // Detect if it's a collection
        if (model instanceof Backbone.Collection) {
            model.on('add remove reset sort', function () {
              this.forceUpdateIfMounted();
            }, this);
        }
        else if (model) {
            var changeOptions = this.changeOptions || 'change';
            model.on(changeOptions, (this.onModelChange || function () {
              this.forceUpdateIfMounted();
            }), this);
        }
    },
    forceUpdateIfMounted: function() {
      if (this.isMounted()) {
        this.forceUpdate();
      } else {
        console.debug('Tried to force update a component that was unmounted. But of course we didn\'t let that happen.');
      }
    },
    _unsubscribe: function(model) {
        if (!model) {
            return;
        }
        model.off(null, null, this);
    },
    componentWillMount: function() {
      if (this.props.model && this.initModel) {
        this.initModel(this.props.model);
      }
    },
    componentDidMount: function() {
        // Whenever there may be a change in the Backbone data, trigger a reconcile.
        this._subscribe(this.props.model, false);
    },
    componentWillReceiveProps: function(nextProps) {
        if (this.props.model !== nextProps.model) {
            this._unsubscribe(this.props.model);
            this._subscribe(nextProps.model, true);
            if (nextProps.model && this.initModel) {
              this.initModel(nextProps.model);
            }
        }
    },
    componentWillUnmount: function() {
        // Ensure that we clean up any dangling references when the component is destroyed.
        this._unsubscribe(this.props.model);
    },
    bindTo: function(model, key){

      var value = model.get(key);

      // Provide a default (empty) value if the value is null or undefined
      if (value == null) {
        value = '';
      }

      return {
          value: value,
          requestChange: function(value){
              model.set(key, value);
          }.bind(this)
      }
    }
};

// module.exports = {
//   componentDidMount: function() {
//     console.warn('component did mount');
//     // Whenever there may be a change in the Backbone data, trigger a reconcile.
//     this.getBackboneModels().forEach(function(model) {
//       model.on('add change remove', this.forceUpdate.bind(this, null), this);
//     }, this);
//   },

//   componentWillUnmount: function() {
//     // Ensure that we clean up any dangling references when the component is
//     // destroyed.
//     this.getBackboneModels().forEach(function(model) {
//       model.off(null, null, this);
//     }, this);
//   }
// };
