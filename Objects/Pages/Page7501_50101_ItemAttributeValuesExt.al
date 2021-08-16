pageextension 50101 ItemAttributeValuesExt extends "Item Attribute Values"
{
    trigger OnClosePage()
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        with ItemAttributeValue do begin
            /*
            We need to reset the Enabled field to clear the Value & "Value 2" fields.
            */
            If FindSet() then
                ModifyAll(Enabled, false);

            /*
            This will set the Enabled field value.
            This will update the "Value 2" and Value.
            */
            CurrPage.SetSelectionFilter(ItemAttributeValue);
            If FindFirst() then
                repeat
                    Enabled := true;
                    Modify();
                until Next() = 0;
        end;

    end;
}