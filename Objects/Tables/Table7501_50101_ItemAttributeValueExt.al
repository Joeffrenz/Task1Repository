tableextension 50101 ItemAttributeValueExt extends "Item Attribute Value"
{
    fields
    {
        //Additional boolean field for multiple selection of values
        field(50100; "Enabled"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enabled';
        }
    }
}