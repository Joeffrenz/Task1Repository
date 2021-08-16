tableextension 50102 ItemAttributeValueMappingExt extends "Item Attribute Value Mapping"
{
    fields
    {
        //Additional field for the multiple value selection
        field(50100; "Value Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}