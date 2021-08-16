
codeunit 50100 "Item Attribute Events"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnAfterUpdateUnitPrice', '', true, true)]
    local procedure "Sales Line_OnValidateNoOnAfterUpdateUnitPrice"
    (
        var SalesLine: Record "Sales Line";
        xSalesLine: Record "Sales Line"
    )
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAssignedAttributes: Text;
    begin
        If SalesLine.Type = SalesLine.Type::Item then begin
            with ItemAttributeValueMapping do begin
                Reset();
                SetRange("No.", SalesLine."No.");
                if FindFirst() then
                    repeat
                        ItemAttribute.Get("Item Attribute ID");
                        if ItemAssignedAttributes = '' then
                            ItemAssignedAttributes := ItemAttribute.Name
                        else
                            ItemAssignedAttributes += ',' + ItemAttribute.Name;
                    until Next() = 0;
            end;
            SalesLine.Attributes := ItemAssignedAttributes;
        end;
    end;
}