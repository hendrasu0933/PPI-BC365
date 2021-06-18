pageextension 63102 "FA GL Journal-Ext" extends "Fixed Asset G/L Journal"
{
    layout
    {
        // Add changes to page layout here


    }

    actions
    {
        // Add changes to page actions here
        addfirst(processing)
        {
            action(Attachments)
            {
                ApplicationArea = basic, suite;
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    GenJnlLine.FindFirst();
                    //GenJnlLine.get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Line No.");
                    Page.RunModal(Page::"General Journal-", GenJnlLine);
                end;
            }
        }

    }

    var
        myInt: Integer;
        tampak: Boolean;
}