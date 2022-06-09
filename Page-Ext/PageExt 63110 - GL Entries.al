pageextension 63110 MyExtension extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(ReverseTransaction)
        {
            action("Bukti Pengeluaran KasBank")
            {
                Caption = 'Bukti Pengeluaran Kas Bank';
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    rec_genJournal: Record "G/L Entry";
                begin
                    rec_genJournal.Reset();
                    rec_genJournal.SetRange("Document No.", Rec."Document No.");
                    // CurrPage.SetSelectionFilter(rec_genJournal);
                    Report.Run(Report::"Bukti Pengeluaran KasBank2", true, true, rec_genJournal);
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}