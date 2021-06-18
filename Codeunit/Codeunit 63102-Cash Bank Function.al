codeunit 63102 "Cash Bank Function"
{
    trigger OnRun()
    begin

    end;
    /*
        [EventSubscriber(objectType::Page, page::"Payment Journal", 'OnInsertRecordEvent', '', true, true)]
        local procedure InsertGenJnl(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; BelowxRec: Boolean; var AllowInsert: Boolean)
        var

        begin
            ModifyAmount(Rec);
        end;
    */
    [EventSubscriber(objectType::Codeunit, codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', true, true)]
    local procedure ModifyGenJnl(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        AppMgt: Codeunit "Approvals Mgmt.";
        GenJournalBatch: Record "Gen. Journal Batch";
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //    if GenJournalLine."Source Code" = 'PAYMENTJNL' then
        //        HideDialog := true;
        GetGeneralJournalBatch(GenJournalBatch, GenJournalLine);
        ModifyAmount(GenJournalLine, GenJournalBatch);
        //   Commit();
        /*
        IF WorkflowManagement.CanExecuteWorkflow(GenJournalBatch, WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode) THEN begin
            IF AppMgt.HasOpenApprovalEntries(GenJournalBatch.RECORDID) OR
            AppMgt.HasAnyOpenJournalLineApprovalEntries(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) then
                Error('An approval request sudah ada.')
            else
                AppMgt.OnSendGeneralJournalBatchForApproval(GenJournalBatch);
            Commit();
            Error('');
        end else begin
            HideDialog := false;
        end;
        */
    end;

    local procedure ModifyAmount(GenJournalLine1: Record "Gen. Journal Line"; var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        RecRestrict: Codeunit "Record Restriction Mgt.";
        Amt: Decimal;
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJournalLine1."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJournalLine1."Journal Batch Name");
        if GenJnlLine.FindSet() then
            repeat
                if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") and (GenJnlLine."Account No." <> '') then
                    Amt := Amt - GenJnlLine."Amount (LCY)"
                else
                    if (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") and (GenJnlLine."Bal. Account No." <> '') then
                        Amt := Amt + GenJnlLine."Amount (LCY)"
            until GenJnlLine.Next() = 0;
        if GenJnlBatch.Amount <> Amt then begin
            GenJnlBatch.Amount := Amt;
            GenJnlBatch.Modify();
            RecRestrict.RestrictRecordUsage(GenJnlBatch, 'Payment Journal ini perlu Approval');
        end;

    end;

    Local procedure GetGeneralJournalBatch(VAR GenJournalBatch: Record "Gen. Journal Batch"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        IF NOT GenJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") THEN
            GenJournalBatch.GET(GenJournalLine.GETFILTER("Journal Template Name"), GenJournalLine.GETFILTER("Journal Batch Name"));
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnAfterFinishPosting', '', true, true)]
    local procedure CheckGLAcc(var GenJournalLine: Record "Gen. Journal Line"; var GlobalGLEntry: Record "G/L Entry"; var GLRegister: Record "G/L Register"; var IsTransactionConsistent: Boolean)
    var

        GLEntries: Record "G/L Entry";
        GLAcc: Record "G/L Account";
    begin

        GLEntries.SetRange("Entry No.", GLRegister."From Entry No.", GLRegister."To Entry No.");
        if GLEntries.FindSet() then
            repeat
                GLAcc.Get(GLEntries."G/L Account No.");
                GLAcc.CalcFields(Balance);
                if (GLAcc."Debit/Credit" = GLAcc."Debit/Credit"::Credit) and (GLAcc.Balance > 0) then
                    Error('COA %1 nilainya tidak boleh positif', GLAcc."No.")
                else
                    if (GLAcc."Debit/Credit" = GLAcc."Debit/Credit"::Debit) and (GLAcc.Balance < 0) then
                        Error('COA %1 nilainya tidak boleh negatif', GLAcc."No.");
            until GLEntries.Next() = 0;
    end;


    var
        myInt: Integer;
}