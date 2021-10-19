codeunit 63106 "Purchase Function"
{
    trigger OnRun()
    begin

    end;
    /*
        [EventSubscriber(objectType::Codeunit, codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
        local procedure onbeforeConfirm(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; var HideDialog: Boolean; var DefaultOption: Integer)
        begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
                CheckAttachment(PurchaseHeader);
        end;

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