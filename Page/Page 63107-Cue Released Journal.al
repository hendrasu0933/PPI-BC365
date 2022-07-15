page 63107 "Released Journal"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Journal Line Document";
    Editable = false;
    layout
    {
        area(Content)
        {
            cuegroup(Finance)
            {
                field("Released Journal"; GetReleasedJnl())
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    begin
                        DrillDownReleasedJnl();
                    end;
                }
            }
        }
    }

    actions
    {


    }
    local procedure GetReleasedJnl(): Integer
    var
        JnlLineDoc: record "Journal Line Document";
    begin
        JnlLineDoc.SetRange(Status, JnlLineDoc.Status::Released);
        JnlLineDoc.SetFilter(Amount, '<>0');
        JnlLineDoc.SetFilter("No. of Lines", '>0');
        if JnlLineDoc.FindFirst() then
            exit(JnlLineDoc.Count);
    end;

    local procedure DrillDownReleasedJnl()
    var
        JnlLineDoc: record "Journal Line Document";
    begin
        JnlLineDoc.FilterGroup(2);
        JnlLineDoc.SetRange(Status, JnlLineDoc.Status::Released);
        JnlLineDoc.SetFilter(Amount, '<>0');
        JnlLineDoc.SetFilter("No. of Lines", '>0');
        JnlLineDoc.FilterGroup(0);
        Page.RunModal(Page::"Journal Line Document", JnlLineDoc);
    end;

    var
        myInt: Integer;
}