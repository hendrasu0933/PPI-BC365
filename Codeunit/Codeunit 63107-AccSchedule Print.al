codeunit 63107 "AccSchedule Print"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(objectType::Table, database::"Acc. Schedule Name", 'OnBeforePrint', '', true, true)]
    local procedure onbeforePrint(var AccScheduleName: Record "Acc. Schedule Name"; var IsHandled: Boolean)
    var
        Report63106: Report 63106;
        Report63107: Report 63107;
        Report63108: Report 63108;
    begin
        if AccScheduleName."Report ID" = 63106 then begin
            IsHandled := true;
            Report63106.SetAccSchedName(AccScheduleName.Name);
            Report63106.SetColumnLayoutName(AccScheduleName."Default Column Layout");
            Report63106.RUN;
        end else
            if AccScheduleName."Report ID" = 63107 then begin
                IsHandled := true;
                Report63107.SetAccSchedName(AccScheduleName.Name);
                Report63107.SetColumnLayoutName(AccScheduleName."Default Column Layout");
                Report63107.RUN;
            end else
                if AccScheduleName."Report ID" = 63108 then begin
                    IsHandled := true;
                    Report63108.SetAccSchedName(AccScheduleName.Name);
                    Report63108.SetColumnLayoutName(AccScheduleName."Default Column Layout");
                    Report63108.RUN;
                end else
                    IsHandled := false;
    end;
    /*
            local procedure CheckAttachment(PurchHeader: Record "Purchase Header")
            var
                IncDoc: Record "Incoming Document";
                IncDocAtt: Record "Incoming Document Attachment";
            begin
                IncDoc.SetRange("Related Record ID", PurchHeader.RecordId);
                if IncDoc.FindFirst() then begin
                    IncDocAtt.SetRange("Incoming Document Entry No.", IncDoc."Entry No.");
                    if not IncDocAtt.FindFirst() then
                        Error('Silakan lampirkan dokumen pendukung dahulu');
                end else
                    Error('Silakan lampirkan dokumen pendukung dahulu');
            end;
        */
    var
        myInt: Integer;
}