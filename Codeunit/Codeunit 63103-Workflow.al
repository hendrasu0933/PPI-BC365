codeunit 63103 "Workflow"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure WFEventLibrary()
    var

    begin
        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnSendBudgetDocForApprovalCode, DATABASE::"G/L Budget Name", BudgetDocSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBudgetApprovalRequestCode, DATABASE::"G/L Budget Name",
          BudgetDocApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseBudgetDocCode, DATABASE::"G/L Budget Name",
          BudgetDocReleasedEventDescTxt, 0, FALSE);
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure WFEventPredecessorLibrary(EventFunctionName: Code[128])
    var

    begin
        CASE EventFunctionName OF
            RunWorkflowOnCancelBudgetApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelBudgetApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
        END;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure WFResponseLibrary(ResponseFunctionName: Code[128])
    var

    begin
        CASE ResponseFunctionName OF
            WFResponseHandling.SetStatusToPendingApprovalCode:
                WFResponseHandling.AddResponsePredecessor(WFResponseHandling.SetStatusToPendingApprovalCode, RunWorkflowOnSendBudgetDocForApprovalCode);
            WFResponseHandling.CreateApprovalRequestsCode:
                WFResponseHandling.AddResponsePredecessor(WFResponseHandling.CreateApprovalRequestsCode, RunWorkflowOnSendBudgetDocForApprovalCode);
            WFResponseHandling.SendApprovalRequestForApprovalCode:
                WFResponseHandling.AddResponsePredecessor(WFResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnSendBudgetDocForApprovalCode);
            WFResponseHandling.ReleaseDocumentCode:
                WFResponseHandling.AddResponsePredecessor(WFResponseHandling.ReleaseDocumentCode, RunWorkflowOnAfterReleaseBudgetDocCode);
            WFResponseHandling.OpenDocumentCode():
                WFResponseHandling.AddResponsePredecessor(WFResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelBudgetApprovalRequestCode());
            WFResponseHandling.CancelAllApprovalRequestsCode:
                WFResponseHandling.AddResponsePredecessor(WFResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelBudgetApprovalRequestCode())
        end;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure CreateWFResponseLibrary()
    var
    begin
        WFResponseHandling.AddResponseToLibrary(SetBudgetStatusToPendingApprovalCode, 0, SetBudgetStatusToPendingApprovalTxt, 'GROUP 0');
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    local procedure ExecuteResponse(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE WorkflowResponse."Function Name" OF
                SetBudgetStatusToPendingApprovalCode:
                    BEGIN
                        WFResponseHandling.SetStatusToPendingApproval(Variant);
                        ResponseExecuted := TRUE;
                    END;
            END;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure ReleaseDoc(RecRef: RecordRef; var Handled: Boolean)
    var
        GLBudget: Record "G/L Budget Name";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SETTABLE(GLBudget);
                    GLBudget.VALIDATE(Status, GLBudget.Status::Released);
                    GLBudget.MODIFY(TRUE);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OpenDoc(RecRef: RecordRef; var Handled: Boolean)
    var
        GLBudget: Record "G/L Budget Name";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SETTABLE(GLBudget);
                    GLBudget.VALIDATE(Status, GLBudget.Status::Open);
                    GLBudget.MODIFY(TRUE);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure SetStatusPending(RecRef: RecordRef; var IsHandled: Boolean; var Variant: Variant)
    var
        GLBudget: Record "G/L Budget Name";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"G/L Budget Name":
                BEGIN
                    RecRef.SETTABLE(GLBudget);
                    GLBudget.VALIDATE(Status, GLBudget.Status::"Pending Approval");
                    GLBudget.MODIFY(TRUE);
                    Variant := GLBudget;
                    IsHandled := true;
                END;
        end;
    end;

    procedure RunWorkflowOnSendBudgetDocForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendBudgetDocForApproval'));
    end;

    procedure RunWorkflowOnCancelBudgetApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelBudgetApprovalRequest'));
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::Workflow, 'OnSendBudgetDocForApproval', '', true, true)]
    procedure RunWorkflowOnSendBudgetDocForApproval(VAR GLBudget: Record "G/L Budget Name")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendBudgetDocForApprovalCode, GLBudget);
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::Workflow, 'OnCancelBudgetDocForApproval', '', true, true)]
    procedure RunWorkflowOnCancelBudgetApprovalRequest(VAR GLBudget: Record "G/L Budget Name")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelBudgetApprovalRequestCode, GLBudget);
    end;

    procedure RunWorkflowOnAfterReleaseBudgetDocCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseBudgetDoc'));
    end;

    procedure RunWorkflowOnAfterReleaseBudgetDoc(VAR GLBudget: Record "G/L Budget Name")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseBudgetDocCode, GLBudget);
    end;

    procedure SetBudgetStatusToPendingApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('SetBudgetStatusToPendingApproval'));
    end;

    procedure CheckBudgetApprovalPossible(VAR GLBudget: Record "G/L Budget Name"): Boolean
    begin
        IF NOT IsBudgetApprovalsWorkflowEnabled(GLBudget) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure IsBudgetApprovalsWorkflowEnabled(VAR GLBudget: Record "G/L Budget Name"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(GLBudget, RunWorkflowOnSendBudgetDocForApprovalCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendBudgetDocForApproval(VAR GLBudget: Record "G/L Budget Name")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelBudgetDocForApproval(VAR GLBudget: Record "G/L Budget Name")
    begin

    end;

    var
        WorkflowResponse: Record "Workflow Response";
        WorkflowManagement: Codeunit "Workflow Management";
        WFResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        BudgetDocSendForApprovalEventDescTxt: Label 'Approval of a budget document is requested.';
        BudgetDocApprReqCancelledEventDescTxt: Label 'An approval request for a budget document is canceled.';
        BudgetDocReleasedEventDescTxt: Label 'A budget document is released.';
        SetBudgetStatusToPendingApprovalTxt: Label 'Set Budget document status to Pending Approval.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        myInt: Integer;
}