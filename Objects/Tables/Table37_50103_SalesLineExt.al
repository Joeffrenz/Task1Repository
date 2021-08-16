tableextension 50103 SalesLineExt extends "Sales Line"
{
    fields
    {
        //additional field for item attributes in sales line
        field(50100; Attributes; Text[250])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}