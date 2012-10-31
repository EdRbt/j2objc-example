- (JavaLangBoolean*)ContainsKeyWithMProperty:(MProperty *)key {
    return [[JavaLangBoolean alloc] initWithBOOL:([_dict objectForKey:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:key.OwnerTypeId] forKey:key.Name]] != NULL)];
}
