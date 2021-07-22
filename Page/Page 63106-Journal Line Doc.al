page 63106 "Journal Line Document"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Journal Line Document";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Journal)
            {
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch"; rec."Journal Batch")
                {
                    ApplicationArea = All;

                }
                field("Journal Template"; rec."Journal Template")
                {
                    ApplicationArea = all;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                trigger OnAction()
                var
                    BudgetFunc: Codeunit "Cash Bank Function";
                begin
                    BudgetFunc.Reopen(Rec);
                    CurrPage.Update();
                end;
            }

        }
    }

    var
        myInt: Integer;
}