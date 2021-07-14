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

        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnSendJournalLineDocForApprovalCode, DATABASE::"Journal Line Document", JournalLineDocSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelJournalLineDocApprovalRequestCode, DATABASE::"Journal Line Document",
          JournalLineDocApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseJournalLineDocCode, DATABASE::"Journal Line Document",
          JournalLineDocReleasedEventDescTxt, 0, FALSE);
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure WFEventPredecessorLibrary(EventFunctionName: Code[128])
    var

    begin
        CASE EventFunctionName OF
            RunWorkflowOnCancelBudgetApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelBudgetApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelJournalLineDocApprovalRequestCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;
        END;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure WFResponseLibrary(ResponseFunctionName: Code[128])
    var

    begin
        CASE ResponseFunctionName OF
            WFResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.SetStatusToPendingApprovalCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.SetStatusToPendingApprovalCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;

            WFResponseHandling.CreateApprovalRequestsCode:
                begin
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.CreateApprovalRequestsCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.CreateApprovalRequestsCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;

            WFResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnSendBudgetDocForApprovalCode);
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnSendJournalLineDocForApprovalCode);
                end;

            WFResponseHandling.ReleaseDocumentCode:
                begin
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.ReleaseDocumentCode, RunWorkflowOnAfterReleaseBudgetDocCode);
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.ReleaseDocumentCode, RunWorkflowOnAfterReleaseJournalLineDocCode);
                end;

            WFResponseHandling.OpenDocumentCode():
                begin
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelBudgetApprovalRequestCode());
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelJournalLineDocApprovalRequestCode());
                end;

            WFResponseHandling.CancelAllApprovalRequestsCode:
                begin
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelBudgetApprovalRequestCode());
                    WFResponseHandling.AddResponsePredecessor(WFResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelJournalLineDocApprovalRequestCode());
                end;


        end;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure CreateWFResponseLibrary()
    var
    begin
        WFResponseHandling.AddResponseToLibrary(SetBudgetStatusToPendingApprovalCode, 0, SetBudgetStatusToPendingApprovalTxt, 'GROUP 0');
        WFResponseHandling.AddResponseToLibrary(SetJournalLineDocStatusToPendingApprovalCode, 0, SetJournalLineDocStatusToPendingApprovalTxt, 'GROUP 0');
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
                SetJournalLineDocStatusToPendingApprovalCode:
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
        JournalLineDoc: Record "Journal Line Document";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SETTABLE(GLBudget);
                    GLBudget.VALIDATE(Status, GLBudget.Status::Released);
                    GLBudget.MODIFY(TRUE);
                    Handled := true;
                end;
            DATABASE::"Journal Line Document":
                begin
                    RecRef.SETTABLE(JournalLineDoc);
                    JournalLineDoc.VALIDATE(Status, JournalLineDoc.Status::Released);
                    JournalLineDoc.MODIFY(TRUE);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OpenDoc(RecRef: RecordRef; var Handled: Boolean)
    var
        GLBudget: Record "G/L Budget Name";
        JournalLineDoc: Record "Journal Line Document";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SETTABLE(GLBudget);
                    GLBudget.VALIDATE(Status, GLBudget.Status::Open);
                    GLBudget.MODIFY(TRUE);
                    Handled := true;
                end;
            DATABASE::"Journal Line Document":
                begin
                    RecRef.SETTABLE(JournalLineDoc);
                    JournalLineDoc.VALIDATE(Status, JournalLineDoc.Status::Open);
                    JournalLineDoc.MODIFY(TRUE);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure SetStatusPending(RecRef: RecordRef; var IsHandled: Boolean; var Variant: Variant)
    var
        GLBudget: Record "G/L Budget Name";
        JournalLineDoc: Record "Journal Line Document";
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
            DATABASE::"Journal Line Document":
                BEGIN
                    RecRef.SETTABLE(JournalLineDoc);
                    JournalLineDoc.VALIDATE(Status, JournalLineDoc.Status::"Pending Approval");
                    JournalLineDoc.MODIFY(TRUE);
                    Variant := JournalLineDoc;
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

    [EventSubscriber(objectType::Table, database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', true, true)]
    procedure BudgetCheckRestriction(sender: Record "Gen. Journal Line")
    var
        GLBudgetName: Record "G/L Budget Name";
        CheckRecRestriction: Codeunit "Record Restriction Mgt.";
    begin
        GLBudgetName.SetRange("Default Budget", true);
        if GLBudgetName.FindFirst() then
            CheckRecRestriction.CheckRecordHasUsageRestrictions(GLBudgetName);
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


    ///--------------------///----------------------///---------------///-----------------
    procedure RunWorkflowOnSendJournalLineDocForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendJournalLineDocForApproval'));
    end;

    procedure RunWorkflowOnCancelJournalLineDocApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelJournalLineDocApprovalRequest'));
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::Workflow, 'OnSendJournalLineDocForApproval', '', true, true)]
    procedure RunWorkflowOnSendJournalLineDocForApproval(VAR JournalLineDoc: Record "Journal Line Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendJournalLineDocForApprovalCode, JournalLineDoc);
    end;

    [EventSubscriber(objectType::Codeunit, codeunit::Workflow, 'OnCancelJournalLineDocForApproval', '', true, true)]
    procedure RunWorkflowOnCancelJournalLineDocApprovalRequest(VAR JournalLineDoc: Record "Journal Line Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelJournalLineDocApprovalRequestCode, JournalLineDoc);
    end;

    [EventSubscriber(objectType::Table, database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', true, true)]
    procedure JnlLineDocCheckRestriction(sender: Record "Gen. Journal Line")
    var
        JnlLineDoc: Record "Journal Line Document";
        CheckRecRestriction: Codeunit "Record Restriction Mgt.";
    begin
        if not JnlLineDoc.Get(sender."Journal Template Name", sender."Journal Batch Name", sender."Document No.") then
            exit;
        CheckRecRestriction.CheckRecordHasUsageRestrictions(JnlLineDoc);
    end;

    procedure RunWorkflowOnAfterReleaseJournalLineDocCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseJournalLineDoc'));
    end;

    procedure RunWorkflowOnAfterReleaseJournalLineDoc(VAR JournalLineDoc: Record "Journal Line Document")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseJournalLineDocCode, JournalLineDoc);
    end;

    procedure SetJournalLineDocStatusToPendingApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('SetJournalLineDocStatusToPendingApproval'));
    end;

    procedure CheckJournalLineDocApprovalPossible(VAR JournalLineDoc: Record "Journal Line Document"): Boolean
    begin
        IF NOT IsJournalLineDocApprovalsWorkflowEnabled(JournalLineDoc) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsJournalLineDocApprovalsWorkflowEnabled(VAR JournalLineDoc: Record "Journal Line Document"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(JournalLineDoc, RunWorkflowOnSendJournalLineDocForApprovalCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendJournalLineDocForApproval(VAR JournalLineDoc: Record "Journal Line Document")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelJournalLineDocForApproval(VAR JournalLineDoc: Record "Journal Line Document")
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
        JournalLineDocSendForApprovalEventDescTxt: Label 'Approval of a Journal Line document is requested.';
        JournalLineDocApprReqCancelledEventDescTxt: Label 'An approval request for a Journal Line document is canceled.';
        JournalLineDocReleasedEventDescTxt: Label 'A Journal Line document is released.';
        SetJournalLineDocStatusToPendingApprovalTxt: Label 'Set Journal Line document status to Pending Approval.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        myInt: Integer;
}