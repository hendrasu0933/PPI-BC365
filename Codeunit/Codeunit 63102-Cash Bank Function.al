codeunit 63102 "Cash Bank Function"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(objectType::Page, page::"Payment Journal", 'OnModifyRecordEvent', '', true, true)]
    local procedure ModifPayJnl(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; var AllowModify: Boolean)
    var

    begin
        if CekStatusGenJnl(Rec) <> 0 then
            Error('Status harus open');
    end;

    [EventSubscriber(objectType::Page, page::"Cash Receipt Journal", 'OnModifyRecordEvent', '', true, true)]
    local procedure ModifcASHJnl(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; var AllowModify: Boolean)
    var

    begin
        if CekStatusGenJnl(Rec) <> 0 then
            Error('Status harus open');
    end;


    [EventSubscriber(objectType::Codeunit, codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', true, true)]
    local procedure ModifyGenJnl(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenLedgSetup: Record "General Ledger Setup";
        GenJournalLine1: Record "Gen. Journal Line";
        DocNo: Code[20];
    begin
        GetGeneralJournalBatch(GenJournalBatch, GenJournalLine);
        GenLedgSetup.Get();
        if GenLedgSetup."Approval Type" = GenLedgSetup."Approval Type"::Batch then begin
            ModifyAmount(GenJournalLine, GenJournalBatch);
        end else
            if GenLedgSetup."Approval Type" = GenLedgSetup."Approval Type"::Line then begin
                GenJournalLine1.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                GenJournalLine1.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                GenJournalLine1.SetCurrentKey("Document No.", "Line No.");
                if GenJournalLine1.FindSet() then
                    repeat
                        if DocNo <> GenJournalLine1."Document No." then begin
                            DocNo := GenJournalLine1."Document No.";
                            ModifyAmount1(GenJournalLine1);
                        end else
                            DocNo := GenJournalLine1."Document No.";
                    until GenJournalLine1.Next() = 0;
            end;
    end;

    local procedure ModifyAmount(GenJournalLine1: Record "Gen. Journal Line"; var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        JnlLineDoc: Record "Journal Line Document";
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

    [EventSubscriber(objectType::Page, page::"Payment Journal", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure OnbeforePostPayJnl(var Rec: Record "Gen. Journal Line")
    begin
        UpdateDim(Rec);
    end;

    [EventSubscriber(objectType::Page, page::"Payment Journal", 'OnBeforeActionEvent', 'SendApprovalRequestJournalBatch', true, true)]
    local procedure OnbeforeSendApprovePayJnl(var Rec: Record "Gen. Journal Line")
    begin
        UpdateDim(Rec);
        Commit();
    end;

    [EventSubscriber(objectType::Page, page::"Cash Receipt Journal", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure OnbeforePostCashJnl(var Rec: Record "Gen. Journal Line")
    begin
        UpdateDim(Rec);
    end;

    [EventSubscriber(objectType::Page, page::"Cash Receipt Journal", 'OnBeforeActionEvent', 'SendApprovalRequestJournalBatch', true, true)]
    local procedure OnbeforeSendApproveCashJnl(var Rec: Record "Gen. Journal Line")
    begin
        UpdateDim(Rec);
        Commit();
    end;

    [EventSubscriber(objectType::Table, database::"Gen. Journal Line", 'OnAfterLookUpAppliesToDocVend', '', true, true)]
    local procedure ApplyDoc(var GenJournalLine: Record "Gen. Journal Line"; VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        CopyAttachment(GenJournalLine, VendLedgEntry."Document No.", VendLedgEntry."Posting Date");
    end;
    //[EventSubscriber(objectType::Table, database::"Gen. Journal Line", 'OnAfterLookUpAppliesToDocVend', '', true, true)]
    //local procedure ApplyDoc()
    local procedure UpdateDim(var Rec: Record "Gen. Journal Line")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        DimMgt: Codeunit DimensionManagement;
        OldParentDim: Integer;
        NewParentDim: Integer;
        NewDim: Integer;
    begin
        if (Rec."Applies-to Doc. No." <> '') and (Rec."Applies-to Doc. Type" = Rec."Applies-to Doc. Type"::Invoice) then begin
            TempGenJnlLine := Rec;
            IF (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) OR
               (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor) OR
               (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Employee)
            THEN
                CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", TempGenJnlLine);
            CASE TempGenJnlLine."Account Type" OF
                TempGenJnlLine."Account Type"::Customer:
                    BEGIN
                        CustLedgEntry.SetRange("Document No.", Rec."Applies-to Doc. No.");
                        CustLedgEntry.SetRange("Document Type", Rec."Applies-to Doc. Type");
                        if CustLedgEntry.FindFirst() then
                            NewParentDim := CustLedgEntry."Dimension Set ID";
                        OldParentDim := Rec."Dimension Set ID";
                        NewDim := DimMgt.GetDeltaDimSetID(Rec."Dimension Set ID", NewParentDim, OldParentDim);
                        if NewDim <> Rec."Dimension Set ID" then begin
                            Rec."Dimension Set ID" := NewDim;
                            DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
                            Rec.Modify()
                        end;
                    end;
                TempGenJnlLine."Account Type"::Vendor:
                    BEGIN
                        VendLedgEntry.SetRange("Document No.", Rec."Applies-to Doc. No.");
                        VendLedgEntry.SetRange("Document Type", Rec."Applies-to Doc. Type");
                        if VendLedgEntry.FindFirst() then
                            NewParentDim := VendLedgEntry."Dimension Set ID";
                        OldParentDim := Rec."Dimension Set ID";
                        NewDim := DimMgt.GetDeltaDimSetID(Rec."Dimension Set ID", NewParentDim, OldParentDim);
                        if NewDim <> Rec."Dimension Set ID" then begin
                            Rec."Dimension Set ID" := NewDim;
                            DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
                            Rec.Modify();
                        end;
                    end;
            end;
        end;
    end;

    local procedure CopyAttachment(var GenJnlLine: Record "Gen. Journal Line"; DocNo: Code[20]; Tgl: Date)
    var
        IncDoc: Record "Incoming Document";
        IncDocAtt: Record "Incoming Document Attachment";
        NewIncDocAtt: Record "Incoming Document Attachment";
        EntryNo: Integer;
    //    VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        IncDocAtt.SetRange("Document No.", DocNo);
        IncDocAtt.SetRange("Posting Date", Tgl);
        if IncDocAtt.FindFirst() then begin
            IncDocAtt.SetRange("Incoming Document Entry No.", IncDocAtt."Incoming Document Entry No.");
            if IncDocAtt.FindSet() then begin
                if GenJnlLine."Incoming Document Entry No." = 0 then begin
                    IncDoc.Insert(true);
                    GenJnlLine.Validate("Incoming Document Entry No.", IncDoc."Entry No.");
                end;
                repeat
                    IncDocAtt.CalcFields(Content);
                    NewIncDocAtt := IncDocAtt;
                    NewIncDocAtt."Incoming Document Entry No." := GenJnlLine."Incoming Document Entry No.";
                    NewIncDocAtt."Document No." := DocNo;
                    NewIncDocAtt."Posting Date" := Tgl;
                    if not NewIncDocAtt.Insert(true) then;

                until IncDocAtt.Next() = 0;

                //    GenJnlLine.Modify();
            end;
        end;
    end;

    procedure ModifyAmount1(GenJournalLine1: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        JnlLineDoc: Record "Journal Line Document";
        RecRestrict: Codeunit "Record Restriction Mgt.";
        Amt: Decimal;
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJournalLine1."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJournalLine1."Journal Batch Name");
        GenJnlLine.SetRange("Document No.", GenJournalLine1."Document No.");
        if GenJnlLine.FindSet() then begin
            repeat
                if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") and (GenJnlLine."Account No." <> '') then
                    Amt := Amt - GenJnlLine."Amount (LCY)"
                else
                    if (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") and (GenJnlLine."Bal. Account No." <> '') then
                        Amt := Amt + GenJnlLine."Amount (LCY)"
            until GenJnlLine.Next() = 0;
            if JnlLineDoc.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.") then begin
                if Amt <> JnlLineDoc.Amount then begin
                    JnlLineDoc.Amount := Amt;
                    JnlLineDoc.Modify();
                end;
            end else begin
                JnlLineDoc."Journal Template" := GenJnlLine."Journal Template Name";
                JnlLineDoc."Journal Batch" := GenJnlLine."Journal Batch Name";
                JnlLineDoc."Document No." := GenJnlLine."Document No.";
                JnlLineDoc.Amount := Amt;
                JnlLineDoc.Insert();
            end;
            RecRestrict.RestrictRecordUsage(JnlLineDoc, 'Payment Journal No ' + JnlLineDoc."Document No." + ' perlu Approval');
        end;
    end;

    procedure CekStatusGenJnl(GenJnlLine: Record "Gen. Journal Line"): Option
    var
        JnlLineDoc: Record "Journal Line Document";
    begin
        if JnlLineDoc.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.") then
            exit(JnlLineDoc.Status)
        else
            exit(JnlLineDoc.Status::Open);
    end;

    procedure MunculkanTombol(): Boolean
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if GLSetup."Approval Type" = GLSetup."Approval Type"::Line then
            exit(true)
        else
            exit(false)
    end;

    procedure Reopen(var Budget: Record "Journal Line Document")
    begin
        if Budget.Status = Budget.Status::Open then
            exit;
        if UserId <> Budget."Released by" then
            Error('Only %1 can reopen this budget', Budget."Released by");
        Budget.Validate(Status, Budget.Status::Open);
    end;

    var
        myInt: Integer;
}