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
        addafter("F&unctions")
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
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
                        ApprovalsMgmt: Codeunit Workflow;
                        GLBudget: Record "G/L Budget Name";
                    begin
                        if GLBudget.Get(BudgetName) then
                            if ApprovalsMgmt.CheckBudgetApprovalPossible(GLBudget) then
                                ApprovalsMgmt.OnSendBudgetDocForApproval(GLBudget);
                    end;
                }
                action(CancelApprovalRequest)
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
                        GLBudget: Record "G/L Budget Name";
                    begin
                        if GLBudget.Get(BudgetName) then begin
                            ApprovalsMgmt.OnCancelBudgetDocForApproval(GLBudget);
                            WorkflowWebhookMgt.FindAndCancel(GLBudget.RecordId);
                        end;
                    end;
                }
            }
        }

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
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
}