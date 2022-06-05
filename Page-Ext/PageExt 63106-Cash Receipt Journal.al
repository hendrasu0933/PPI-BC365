pageextension 63106 "Cash Receipt Journal-Ext" extends "Cash Receipt Journal"
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
            action("Cash Receipt")
            {
                Image = PrintForm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    recTransfer: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(recTransfer);
                    Report.Run(Report::"Cash Receipt", true, true, recTransfer);
                end;
            }
            action("Bukti Penerimaan KasBank")
            {
                Caption = 'Bukti Penerimaan Kas Bank';
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
                    Report.Run(Report::"Bukti Penerima KasBank", true, true, rec_genJournal);
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
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reopen';

                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        CashBankFunc: Codeunit "Cash Bank Function";
                    begin
                        CashBankFunc.ReopenStatusGenJnl(Rec);
                    end;
                }
            }
        }


    }

    var
        CashFunc: Codeunit "Cash Bank Function";
        myInt: Integer;
}