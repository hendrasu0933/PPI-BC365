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

    procedure CreateCommitBudget(Tgl: date; BudgetName: Code[10]; Description: text[100]; GLAccNo: Code[20]; GlobalDim1: Code[20]; GlobalDim2: Code[20]; Amount: Decimal)
    var
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        GLBudgetEntry.Date := Tgl;
        GLBudgetEntry."G/L Account No." := GLAccNo;
        GLBudgetEntry."Budget Name" := BudgetName;
        GLBudgetEntry.Description := Description;
        GLBudgetEntry.Validate("Global Dimension 1 Code", GlobalDim1);
        GLBudgetEntry.Validate("Global Dimension 2 Code", GlobalDim2);
        GLBudgetEntry.Insert(true);
    end;

    procedure CheckOverBudget(GLAccNo: Code[20]; GlobalDim1: Code[20]; GlobalDim2: Code[20]; BudgetName: code[10]; CommitBudgetName: code[10]; DateFilter: Text)
    var
        GlAcc1: Record "G/L Account";
        GlAcc2: Record "G/L Account";
    begin
        GlAcc1.Get(GLAccNo);
        if GlobalDim1 <> '' then
            GlAcc1.SetRange("Global Dimension 1 Filter", GlobalDim1);
        if GlobalDim2 <> '' then
            GlAcc1.SetRange("Global Dimension 2 Filter", GlobalDim2);
        if DateFilter <> '' then
            GlAcc1.SetFilter("Date Filter", DateFilter);
    end;

    var
        myInt: Integer;
}