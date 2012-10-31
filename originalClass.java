public MObject GetValue(MProperty prop)
    {
        if (!_currentValues.ContainsKey(prop)) {
            if (_bindings.ContainsKey(prop)) {
                return ((MLinkedValue)_bindings.Get(prop)).GetValue();
            }
            else if (IsDefined(prop)) {
                SetCurrentValue(prop, ((MValue)DefinedValues.Get(prop)).GetValue());
            }
            else if ((prop.Flags & MPropertyFlags.PropagateToChildren) == MPropertyFlags.PropagateToChildren && this.Parent != null) {
                return Parent.GetValue(prop);
            }
            else if ((prop.Flags & MPropertyFlags.Collection) == MPropertyFlags.Collection) {
                MElement collection = (MElement)MElement.CreateElement(prop.TypeId);
                AddChild(collection);
                SetValue(prop, collection);
                SetCurrentValue(prop, collection);
                this.NotifyObservers(prop.Name);
                OnPropertyChanged(prop, collection);
            }
            else {
                if (prop.DefaultValue == null) return null;
                SetCurrentValue(prop, prop.DefaultValue.Clone());
            }
        }
        return _currentValues.Get(prop);
    }
