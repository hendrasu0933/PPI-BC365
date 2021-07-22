pageextension 63105 "Payment Journal-Ext" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Amount (LCY)")
        {
            field(Status; CashFunc.CekStatusGenJnl(Rec))
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(Preview)
        {
            action("BKK <= 200")
            {
                Caption = 'BKK Per-Line';
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    rec_genJournal: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(rec_genJournal);
                    Report.Run(Report::"BKK Min 200", true, true, rec_genJournal);
                end;
            }
            action("BKK Batch")
            {
                Caption = 'BKK Per-Batch';
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                Visible = false;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    rec_genJournal: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(rec_genJournal);
                    Report.Run(Report::"BKK Min 200 Batch", true, true, rec_genJournal);
                end;
            }
        }
        addafter("F&unctions")
        {
            group("Request Approval Ext")
            {
                Caption = 'Request Approval Custom';
                Image = SendApprovalRequest;
                //Visible = CashBankFunc.MunculkanTombol();
                action(SendApprovalRequestExt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    //    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        JnlLineDoc: Record "Journal Line Document";
                        ApprovalsMgmt: Codeunit Workflow;
                        CashBankFunc: Codeunit "Cash Bank Function";
                    begin

                        CashBankFunc.ModifyAmount1(Rec);
                        Commit();
                        if JnlLineDoc.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Document No.") then
                            if ApprovalsMgmt.CheckJournalLineDocApprovalPossible(JnlLineDoc) then
                                ApprovalsMgmt.OnSendJournalLineDocForApproval(JnlLineDoc);
                    end;
                }
                action(CancelApprovalRequestExt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    //    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit Workflow;
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                        JnlLineDoc: Record "Journal Line Document";
                    begin
                        if JnlLineDoc.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Document No.") then begin
                            ApprovalsMgmt.OnCancelJournalLineDocForApproval(JnlLineDoc);
                            WorkflowWebhookMgt.FindAndCancel(JnlLineDoc.RecordId);
                        end;
                    end;
                }
            }
        }

    }

    var
        CashFunc: Codeunit "Cash Bank Function";
        myInt: Integer;
}