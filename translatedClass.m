- (MObject *)GetValueWithMProperty:(MProperty *)prop {
  if (![((PropertyValueDictionary *) NIL_CHK(_currentValues_)) ContainsKeyWithMProperty:prop]) {
    if ([[((PropertyValueDictionary *) NIL_CHK(_bindings_)) ContainsKeyWithMProperty:prop] booleanValue]) {
      return [((MLinkedValue *) [((PropertyValueDictionary *) NIL_CHK(_bindings_)) GetWithMProperty:prop]) GetValue];
    }
    else if ([self IsDefinedWithMProperty:prop]) {
      [self SetCurrentValueWithMProperty:prop withMObject:[((MValue *) [((PropertyValueDictionary *) NIL_CHK(DefinedValues_)) GetWithMProperty:prop]) GetValue]];
    }
    else if ((((MProperty *) NIL_CHK(prop)).Flags & MPropertyFlags_PropagateToChildren) == MPropertyFlags_PropagateToChildren && self.Parent != nil) {
      return [((MElement *) NIL_CHK(Parent_)) GetValueWithMProperty:prop];
    }
    else if ((((MProperty *) NIL_CHK(prop)).Flags & MPropertyFlags_Collection) == MPropertyFlags_Collection) {
      MElement *collection = (MElement *) [MElement CreateElementWithInt:((MProperty *) NIL_CHK(prop)).TypeId];
      [self AddChildWithMElement:collection];
      [self SetValueWithMProperty:prop withMObject:collection];
      [self SetCurrentValueWithMProperty:prop withMObject:collection];
      [self NotifyObserversWithNSString:((MProperty *) NIL_CHK(prop)).Name];
      [self OnPropertyChangedWithMProperty:prop withMObject:collection];
    }
    else {
      if (((MProperty *) NIL_CHK(prop)).DefaultValue == nil) return nil;
      [self SetCurrentValueWithMProperty:prop withMObject:[((MBasicValue *) NIL_CHK(prop.DefaultValue)) Clone]];
    }
  }
  return [((PropertyValueDictionary *) NIL_CHK(_currentValues_)) GetWithMProperty:prop];
}
