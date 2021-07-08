pageextension 63104 "GL Budget Name-Ext" extends "G/L Budget Names"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Status; rec.Status)
            {
                ApplicationArea = all;
            }

            field("Default Budget"; rec."Default Budget")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(EditBudget)
        {
            action(Reopen)
            {
                trigger OnAction()
                var
                    BudgetFunc: Codeunit "Budget Function";
                begin
                    BudgetFunc.Reopen(Rec);
                    CurrPage.Update();
                end;
            }
            action("Make Default")
            {
                trigger OnAction()
                var
                    BudgetFunc: Codeunit "Budget Function";
                begin
                    BudgetFunc.MakeDefault(Rec);
                    CurrPage.Update();
                end;
            }
        }

    }

    var
        myInt: Integer;
}