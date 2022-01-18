pageextension 63150 PageExtGeneralJournal extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Approval)
        {
            action("Bukti Journal Rupa Rupa")
            {
                // Caption = 'Bukti Pengeluaran Kas Bank';
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
                    Report.Run(Report::"Bukti Jurnal Rupa Rupa", true, true, rec_genJournal);
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}