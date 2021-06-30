codeunit 63104 "Budget Function"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(objectType::table, database::"G/L Budget Entry", 'OnInsertOnAfterUpdateDimSets', '', true, true)]
    local procedure InsertBudget(var GLBudgetEntry: Record "G/L Budget Entry"; var TempDimensionSetEntry: Record "Dimension Set Entry")
    var
        GLBudgetName: Record "G/L Budget Name";
    begin
        GLBudgetName.Get(GLBudgetEntry."Budget Name");
        GLBudgetName.TestField(Status, GLBudgetName.Status::Open);
    end;


    var
        myInt: Integer;
}