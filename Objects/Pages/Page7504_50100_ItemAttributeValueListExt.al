pageextension 50100 ItemAttributeValueListExt extends "Item Attribute Value List"
{
    layout
    {
        //This code will hide the standard value field
        modify(Value)
        {
            Visible = false;
        }
        addafter("Attribute Name")
        {
            field(Enabled; Rec."Value 2")
            {
                //this is our created field for this customization
                Caption = 'Value';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    ItemAttributeValue: Record "Item Attribute Value";
                    ItemAttribute: Record "Item Attribute";
                    Values: Text;
                begin
                    ItemAttribute.Get(Rec."Attribute ID");
                    //We need to check if the attribute type is option
                    if ItemAttribute.Type = ItemAttribute.Type::Option then begin
                        ItemAttributeValue.Reset();
                        ItemAttributeValue.SetRange("Attribute ID", Rec."Attribute ID");
                        if ItemAttributeValue.FindSet() then begin
                            /*
                            If the attribute type is option, these codes will open Item Attribute Values 
                            page instead of the standarddialog page. In that way, we can select multiple attribute values.
                            */
                            if Page.RunModal(Page::"Item Attribute Values", ItemAttributevalue) = Action::LookupOK then begin
                                with ItemAttributeValue do begin
                                    Reset();
                                    SetRange(Enabled, true);
                                    SetRange(Blocked, false);
                                    if FindFirst() then
                                        repeat
                                            //We need concatenate all values selected from the list and separate it with comma.
                                            if Values = '' then
                                                Values := Value
                                            else
                                                Values += ',' + Value;
                                        until Next() = 0;
                                end;

                                //Update the Item Attribute Value Mapping's "Value Name".
                                with ItemAttributeValueMapping do begin
                                    SetRange("Table ID", DATABASE::Item);
                                    SetRange("No.", RelatedRecordCode);
                                    SetRange("Item Attribute ID", ItemAttributeValue."Attribute ID");
                                    if FindFirst then begin
                                        "Value Name" := Values;
                                        Modify();
                                    end;
                                end;
                                Rec."Value 2" := Values;
                            end;
                        end;
                    end;
                end;

                trigger OnValidate()
                var
                    ItemAttributeValue: Record "Item Attribute Value";
                    ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    ItemAttribute: Record "Item Attribute";
                begin
                    /*
                    Set the Value field equal to "Value 2" field.
                    */
                    Rec.Value := Rec."Value 2";
                    Rec.Modify(true);
                    /*
                    These codes here, are the same codes with standard value field from Item Attribute Value list.
                    In this way, our customization will run just like how the standard Value field works.
                    */
                    if not FindAttributeValue(ItemAttributeValue) then
                        InsertItemAttributeValue(ItemAttributeValue, Rec);

                    ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
                    ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
                    ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttributeValue."Attribute ID");
                    if ItemAttributeValueMapping.FindFirst then begin
                        ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                        OnBeforeItemAttributeValueMappingModify(ItemAttributeValueMapping, ItemAttributeValue, RelatedRecordCode);
                        ItemAttributeValueMapping."Value Name" := Rec.Value;
                        ItemAttributeValueMapping.Modify();
                        OnAfterItemAttributeValueMappingModify(ItemAttributeValueMapping, Rec);
                    end;

                    ItemAttribute.Get("Attribute ID");
                    if ItemAttribute.Type <> ItemAttribute.Type::Option then
                        if FindAttributeValueFromRecord(ItemAttributeValue, xRec) then
                            if not ItemAttributeValue.HasBeenUsed then
                                ItemAttributeValue.Delete();

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        //This will display the attribute values in the attribute value list page.
        CopyValue(RelatedRecordCode);
        with ItemAttributeValueMapping do begin
            Reset();
            SetRange("No.", RelatedRecordCode);
            if FindFirst() then
                repeat
                    Rec.Reset();
                    Rec.SetRange("Attribute ID", "Item Attribute ID");
                    if Rec.FindFirst() then begin
                        Rec."Value 2" := "Value Name";
                        Rec.Modify();
                    end;
                until Next() = 0;
        end;
        Rec.Reset();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterItemAttributeValueMappingModify(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping"; ItemAttributeValueSelection: Record "Item Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeItemAttributeValueMappingModify(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping"; ItemAttributeValue: Record "Item Attribute Value"; RelatedRecordCode: Code[20])
    begin
    end;

    local procedure CopyValue(ItemCode: Code[20])
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttribute: Record "Item Attribute";
    begin
        with ItemAttributeValueMapping do begin
            Reset();
            SetRange("No.", ItemCode);
            if FindFirst() then
                repeat
                    ItemAttributeValue.Reset();
                    ItemAttributeValue.SetRange("Attribute ID", "Item Attribute ID");
                    ItemAttributeValue.SetRange(ID, "Item Attribute Value ID");
                    if ItemAttributeValue.FindFirst() then begin
                        ItemAttribute.get("Item Attribute ID");
                        if ItemAttributeValue.Value <> '' then begin
                            "Value Name" := ItemAttributeValue.Value;
                            Modify();
                        end;
                    end;
                until Next() = 0;
        end;
    end;

}