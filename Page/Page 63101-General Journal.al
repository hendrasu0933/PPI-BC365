page 63101 "General Journal-"
{
    // // This page has two view modes based on global variable 'IsSimplePage' as :-
    // // Classic mode (Show more columns action) - When IsSimplePage is set to false. This view supports showing all the traditional columns. All the lines for all
    // // document numbers are shown in this view.
    // // Simple mode (Show less columns actions) - When IsSimplePage is set to True. This view supports limitted columns and pulls document number, posting date,
    // // currency code as global variables. This mode is intented to do fast data entry so only ONE document number is shown at a time. User can
    // // use next / previous buttons to navigate between different document numbers.
    // // By default this page opens up in Simple mode; if users chooses to switch to classic mode (show more columns) then we remember their selection in Journal User Preferences table

    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field("Document No."; rec."Document No.")
            {
                ApplicationArea = basic, suite;
            }
            field(Description; rec.Description)
            {
                ApplicationArea = basic, suite;
            }
        }
        area(factboxes)
        {

            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }

        }
    }

    actions
    {



    }

    trigger OnAfterGetCurrRecord()
    begin

        // PostedFromSimplePage is set to TRUE when 'POST' / 'POST+PRINT' action is executed in simple page mode.
        // It gets set to FALSE when OnNewRecord is called in the simple mode.
        // After posting we try to find the first record and filter on its document number
        // Executing LoaddataFromRecord for incomingDocAttachFactbox is also forcing this (PAG39) page to update
        // and for some reason after posting this page doesn't refresh with the filter set by POST / POST-PRINT action in simple mode.
        // To resolve this only call LoaddataFromRecord if PostedFromSimplePage is FALSE.
        if not PostedFromSimplePage then
            CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

    end;

    trigger OnAfterGetRecord()
    begin

        HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
        CurrPage.IncomingDocAttachFactBox.PAGE.SetCurrentRecordID(rec.RecordId);

    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        PayrollManagement: Codeunit "Payroll Management";
        ClientTypeManagement: Codeunit "Client Type Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
        CurrentJnlBatchName: Code[10];
        AccName: Text[100];
        BalAccName: Text[100];
        Balance: Decimal;
        TotalBalance: Decimal;
        NumberOfRecords: Integer;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        Text000: Label 'General Journal lines have been successfully inserted from Standard General Journal %1.';
        Text001: Label 'Standard General Journal %1 has been successfully created.';
        HasIncomingDocument: Boolean;
        ApplyEntriesActionEnabled: Boolean;
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        StyleTxt: Text;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        ImportPayrollTransactionsAvailable: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanRequestFlowApprovalForBatchAndAllLines: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanCancelFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
        AmountVisible: Boolean;
        DebitCreditVisible: Boolean;
        IsSaaS: Boolean;
        IsSimplePage: Boolean;
        JobQueuesUsed: Boolean;
        JobQueueVisible: Boolean;
        BackgroundErrorCheck: Boolean;
        ShowAllLinesEnabled: Boolean;
        CurrentDocNo: Code[20];
        CurrentPostingDate: Date;
        CurrentCurrencyCode: Code[10];
        IsChangingDocNo: Boolean;
        MissingExchangeRatesQst: Label 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', Comment = '%1 - currency code, %2 - posting date';
        PostedFromSimplePage: Boolean;
        DocumentNumberMsg: Label 'Document No. must have a value in Gen. Journal Line.';

    protected var
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;



}

