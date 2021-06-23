pageextension 63103 "Budget-Ext" extends Budget
{
    layout
    {
        // Add changes to page layout here
        addafter(BudgetName)
        {
            field(Status; getstatus(BudgetName))
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here

    }
    procedure getstatus(name: Code[10]): Text
    var
        GLBudget: Record "G/L Budget Name";
    begin
        if GLBudget.Get(name) then
            exit(format(GLBudget.Status))
    end;

    var
        myInt: Integer;
}