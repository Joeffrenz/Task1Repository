pageextension 50104 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        addafter(Description)
        {
            //additional field for Item Attributes
            field(Attributes; Rec.Attributes)
            {
                ApplicationArea = All;
                Caption = 'Item Attributes';
            }
        }
    }
}