pageextension 63106 "Cash Receipt Journal-Ext" extends "Cash Receipt Journal"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        addafter(Preview)
        {
            action("Cash Receipt")
            {
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    recTransfer: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(recTransfer);
                    Report.Run(Report::"Cash Receipt", true, true, recTransfer);
                end;
            }
        }

    }

    var
        myInt: Integer;
}