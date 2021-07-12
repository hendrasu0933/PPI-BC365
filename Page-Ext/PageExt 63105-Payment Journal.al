pageextension 63105 "Payment Journal-Ext" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        addafter(Preview)
        {
            action("BKK <= 200")
            {
                Caption = 'BKK Per-Line';
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    rec_genJournal: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(rec_genJournal);
                    Report.Run(Report::"BKK Min 200", true, true, rec_genJournal);
                end;
            }
            action("BKK Batch")
            {
                Caption = 'BKK Per-Batch';
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    rec_genJournal: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(rec_genJournal);
                    Report.Run(Report::"BKK Min 200 Batch", true, true, rec_genJournal);
                end;
            }
        }

    }

    var
        myInt: Integer;
}