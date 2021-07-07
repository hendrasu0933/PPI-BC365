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

    [EventSubscriber(objectType::Codeunit, codeunit::"Purch.-Post", 'OnPostUpdateInvoiceLineOnAfterPurchOrderLineModify', '', true, true)]
    local procedure UpdateBudget(var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        CommBudget: Record "G/L Budget Name";
        CurFact: Decimal;
    begin
        CommBudget.SetRange("Committed Budget", true);
        CommBudget.FindFirst();
        PurchHeader.get(PurchaseLine."Document No.");
        if PurchHeader."Currency Factor" = 0 then
            CurFact := 1
        else
            CurFact := PurchHeader."Currency Factor";
        if PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
            CreateCommitBudget(PurchHeader."Posting Date", CommBudget.Name, PurchaseLine."Document No." + ';' + Format(PurchaseLine."Line No."), PurchaseLine."No.",
            PurchaseLine."Shortcut Dimension 1 Code", '', (TempPurchaseLine."Qty. to Invoice" * PurchaseLine.Amount) / (CurFact * PurchaseLine.Quantity))
        else
            CreateCommitBudget(PurchHeader."Posting Date", CommBudget.Name, PurchaseLine."Document No." + ';' + Format(PurchaseLine."Line No."), PurchaseLine."G/L Acc. No.",
            PurchaseLine."Shortcut Dimension 1 Code", '', -(TempPurchaseLine."Qty. to Invoice" * PurchaseLine.Amount) / (CurFact * PurchaseLine.Quantity))
    end;

    [EventSubscriber(objectType::table, database::"Purchase Line", 'OnAfterValidateEvent', 'Direct Unit Cost', true, true)]
    local procedure AddGlAccNo(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        FAPostingGr: Record "FA Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        InvPostingSetup: Record "Inventory Posting Setup";
        Item: Record Item;
    begin
        if Rec.Type = Rec.Type::"Fixed Asset" then begin
            FAPostingGr.get(Rec."Posting Group");
            Rec."G/L Acc. No." := FAPostingGr."Acquisition Cost Account";
        end else
            if (Rec.Type = Rec.Type::Item) and Rec.IsNonInventoriableItem() then begin
                GenPostingSetup.get(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group");
                Rec."G/L Acc. No." := GenPostingSetup."Purch. Account";
            end else
                if (Rec.Type = Rec.Type::Item) and Rec.IsInventoriableItem() then begin
                    Item.get(Rec."No.");
                    if Item."Costing Method" = Item."Costing Method"::Standard then begin
                        GenPostingSetup.get(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group");
                        Rec."G/L Acc. No." := GenPostingSetup."Purchase Variance Account";
                    end else begin
                        InvPostingSetup.get(Rec."Location Code", Rec."Posting Group");
                        Rec."G/L Acc. No." := InvPostingSetup."Inventory Account";
                    end;
                end

    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Release Purchase Document", 'OnBeforeModifyPurchDoc', '', true, true)]
    local procedure ReleasedDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    var
        PurchLine: Record "Purchase Line";
        BankAccStat: Record "Bank Account Statement" temporary;
        GenPostSetup: Record "General Posting Setup";
        DefBudget: Record "G/L Budget Name";
        CommBudget: Record "G/L Budget Name";
        CurFact: Decimal;
    begin
        if PurchaseHeader.Status = PurchaseHeader.Status::Open then begin
            PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchLine.SetRange("Document No.", PurchaseHeader."No.");
            PurchLine.SetFilter("Line Amount", '<>0');
            Message('2');
            if PurchaseHeader."Currency Factor" = 0 then
                CurFact := 1
            else
                CurFact := PurchaseHeader."Currency Factor";
            if PurchLine.FindSet() then
                repeat
                    if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
                        if BankAccStat.Get(PurchLine."No.", PurchLine."Shortcut Dimension 1 Code") then begin
                            BankAccStat."Balance Last Statement" := BankAccStat."Balance Last Statement" + PurchLine.Amount / CurFact;
                            BankAccStat.Modify();
                        end else begin
                            BankAccStat."Bank Account No." := PurchLine."No.";
                            BankAccStat."Statement No." := PurchLine."Shortcut Dimension 1 Code";
                            BankAccStat."Balance Last Statement" := PurchLine.Amount / CurFact;
                            BankAccStat.Insert();
                        end;
                    end else

                        if BankAccStat.Get(PurchLine."G/L Acc. No.", PurchLine."Shortcut Dimension 1 Code") then begin
                            BankAccStat."Balance Last Statement" := BankAccStat."Balance Last Statement" + PurchLine.Amount / CurFact;
                            BankAccStat.Modify();
                        end else begin
                            BankAccStat."Bank Account No." := PurchLine."G/L Acc. No.";
                            BankAccStat."Statement No." := PurchLine."Shortcut Dimension 1 Code";
                            BankAccStat."Balance Last Statement" := PurchLine.Amount / CurFact;
                            BankAccStat.Insert();
                        end;
                until PurchLine.Next() = 0;
            CommBudget.SetRange("Committed Budget", true);
            CommBudget.FindFirst();
            DefBudget.SetRange("Default Budget", true);
            DefBudget.FindFirst();
            if BankAccStat.FindSet() then begin
                repeat
                    CheckOverBudget(BankAccStat."Bank Account No.", BankAccStat."Statement No.", '', DefBudget.Name, CommBudget.Name, CalcDate('-CY', PurchaseHeader."Posting Date"), CalcDate('CY', PurchaseHeader."Posting Date"), BankAccStat."Balance Last Statement");
                until BankAccStat.Next() = 0;
            end;
            if PurchLine.Find('-') then
                repeat
                    if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
                        CreateCommitBudget(PurchaseHeader."Posting Date", CommBudget.Name, format(PurchaseHeader."No.") + ';' + format(PurchLine."Line No."), PurchLine."No.", PurchLine."Shortcut Dimension 1 Code", '', PurchLine.Amount / CurFact);
                    end else begin
                        CreateCommitBudget(PurchaseHeader."Posting Date", CommBudget.Name, format(PurchaseHeader."No.") + ';' + format(PurchLine."Line No."), PurchLine."G/L Acc. No.", PurchLine."Shortcut Dimension 1 Code", '', PurchLine.Amount / CurFact);
                    end;
                until PurchLine.Next() = 0;
        end;
    end;

    [EventSubscriber(objectType::table, database::"Purchase Header", 'OnAfterValidateEvent', 'Status', true, true)]
    local procedure SetPendingApproval(CurrFieldNo: Integer; var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        BankAccStat: Record "Bank Account Statement" temporary;
        GenPostSetup: Record "General Posting Setup";
        DefBudget: Record "G/L Budget Name";
        CommBudget: Record "G/L Budget Name";
        CurFact: Decimal;
        DateFilter: Text;
    begin

        if ((xRec.Status = xRec.Status::Open) and (Rec.Status = Rec.Status::"Pending Approval")) then begin
            PurchLine.SetRange("Document Type", Rec."Document Type");
            PurchLine.SetRange("Document No.", Rec."No.");
            PurchLine.SetFilter("Line Amount", '<>0');

            if Rec."Currency Factor" = 0 then
                CurFact := 1
            else
                CurFact := Rec."Currency Factor";
            if PurchLine.FindSet() then
                repeat
                    if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
                        if BankAccStat.Get(PurchLine."No.", PurchLine."Shortcut Dimension 1 Code") then begin
                            BankAccStat."Balance Last Statement" := BankAccStat."Balance Last Statement" + PurchLine.Amount / CurFact;
                            BankAccStat.Modify();
                        end else begin
                            BankAccStat."Bank Account No." := PurchLine."No.";
                            BankAccStat."Statement No." := PurchLine."Shortcut Dimension 1 Code";
                            BankAccStat."Balance Last Statement" := PurchLine.Amount / CurFact;
                            BankAccStat.Insert();
                        end;
                    end else

                        if BankAccStat.Get(PurchLine."G/L Acc. No.", PurchLine."Shortcut Dimension 1 Code") then begin
                            BankAccStat."Balance Last Statement" := BankAccStat."Balance Last Statement" + PurchLine.Amount / CurFact;
                            BankAccStat.Modify();
                        end else begin
                            BankAccStat."Bank Account No." := PurchLine."G/L Acc. No.";
                            BankAccStat."Statement No." := PurchLine."Shortcut Dimension 1 Code";
                            BankAccStat."Balance Last Statement" := PurchLine.Amount / CurFact;
                            BankAccStat.Insert();
                        end;
                until PurchLine.Next() = 0;
            CommBudget.SetRange("Committed Budget", true);
            CommBudget.FindFirst();
            DefBudget.SetRange("Default Budget", true);
            DefBudget.FindFirst();
            if BankAccStat.FindSet() then begin
                repeat
                    CheckOverBudget(BankAccStat."Bank Account No.", BankAccStat."Statement No.", '', DefBudget.Name, CommBudget.Name, CalcDate('-CY', Rec."Posting Date"), CalcDate('CY', Rec."Posting Date"), BankAccStat."Balance Last Statement");
                until BankAccStat.Next() = 0;
            end;
            if PurchLine.Find('-') then
                repeat
                    if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
                        CreateCommitBudget(Rec."Posting Date", CommBudget.Name, format(Rec."No.") + ';' + format(PurchLine."Line No."), PurchLine."No.", PurchLine."Shortcut Dimension 1 Code", '', PurchLine.Amount / CurFact);
                    end else begin
                        CreateCommitBudget(Rec."Posting Date", CommBudget.Name, format(Rec."No.") + ';' + format(PurchLine."Line No."), PurchLine."G/L Acc. No.", PurchLine."Shortcut Dimension 1 Code", '', PurchLine.Amount / CurFact);
                    end;
                until PurchLine.Next() = 0;
        end
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Release Purchase Document", 'OnAfterReopenPurchaseDoc', '', true, true)]
    local procedure ReopenPurc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        Message('reopen');
        DeleteCommitBudget(PurchaseHeader."No.");
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
        GLBudgetEntry.Amount := Amount;
        GLBudgetEntry.Insert(true);
    end;

    procedure DeleteCommitBudget(Description: Text[100])
    var
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        if Description <> '' then begin
            GLBudgetEntry.SetFilter(Description, Description + '*');
            GLBudgetEntry.DeleteAll(true);
        end;
    end;

    procedure CheckOverBudget(GLAccNo: Code[20]; GlobalDim1: Code[20]; GlobalDim2: Code[20]; BudgetName: code[10]; CommitBudgetName: code[10]; StartDate: Date; EndDate: Date; Amt: Decimal)
    var
        GlAcc1: Record "G/L Account";
        GlAcc2: Record "G/L Account";
    begin
        GlAcc1.Get(GLAccNo);
        if GlAcc1."Account Category" = GlAcc1."Account Category"::Expense then begin
            if GlobalDim1 <> '' then
                GlAcc1.SetFilter("Global Dimension 1 Filter", GlobalDim1);
            if GlobalDim2 <> '' then
                GlAcc1.SetFilter("Global Dimension 2 Filter", GlobalDim2);
            if (StartDate <> 0D) and (EndDate <> 0D) then
                GlAcc1.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
            if BudgetName <> '' then
                GlAcc1.SetFilter("Budget Filter", BudgetName);
            GlAcc1.CalcFields("Budgeted Amount");
            GlAcc2.Get(GLAccNo);
            if GlobalDim1 <> '' then
                GlAcc2.SetFilter("Global Dimension 1 Filter", GlobalDim1);
            if GlobalDim2 <> '' then
                GlAcc2.SetFilter("Global Dimension 2 Filter", GlobalDim2);
            if (StartDate <> 0D) and (EndDate <> 0D) then
                GlAcc2.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
            if CommitBudgetName <> '' then
                GlAcc2.SetFilter("Budget Filter", CommitBudgetName);
            GlAcc2.CalcFields("Net Change", "Budgeted Amount");
            if GlAcc1."Budgeted Amount" < GlAcc2."Net Change" + GlAcc2."Budgeted Amount" + Amt then
                Error('Sudah melebihi budget')
            else
                if GlAcc1."Budgeted Amount" * 85 / 100 < GlAcc2."Net Change" + GlAcc2."Budgeted Amount" + Amt then
                    if not Confirm('Sudah melebihi 85% dari budget yang ada. Apakah anda tetap melanjutkan transaksi ini?') then
                        Error('');
        end;
    end;

    procedure Reopen(var Budget: Record "G/L Budget Name")
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