report 63105 "BKK Min 200 Batch"
{
    Caption = 'BKK Batch';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63102 - BKK Min 200 batch.rdlc';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(Line_No_; "Line No.") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Journal_Template_Name; "Journal Template Name") { }
            column(CompanyInformasi; CompanyInformasi.City) { }
            column(Posting_Date; "Posting Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Amount; Amount) { }
            column(Amount__LCY_; "Amount (LCY)") { }
            column(Bal__Account_Type; "Bal. Account Type") { }
            column(Bal__Account_No_; "Bal. Account No.") { }
            column(t_AddressCustomer; text.UpperCase(t_AddressCustomer)) { }
            column(t_NameCustomer; text.UpperCase(t_NameCustomer)) { }
            column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
            column(Document_No_; "Document No.") { }
            column(AmountInWords; text.UpperCase(AmountInWords)) { }
            column(Description; Description) { }
            column(t_NameBank; t_NameBank) { }
            column(DescriptionUpperCase; text.UpperCase("Message to Recipient")) { }
            column(d_ApproveDate1; d_ApproveDate[1]) { }
            column(d_ApproveDate2; d_ApproveDate[2]) { }
            column(d_ApproveDate3; d_ApproveDate[3]) { }
            column(d_ApproveDate4; d_ApproveDate[4]) { }
            column(d_ApproveDate5; d_ApproveDate[5]) { }
            column(t_ApproveText1; t_ApproveText[1]) { }
            column(t_ApproveText2; t_ApproveText[2]) { }
            column(t_ApproveText3; t_ApproveText[3]) { }
            column(t_ApproveText4; t_ApproveText[4]) { }
            column(t_ApproveText5; t_ApproveText[5]) { }
            column(i_rows; i_rows) { }
            trigger OnAfterGetRecord()
            var
                rec_Customer: Record Customer;
                rec_Vendor: Record Vendor;
                rec_PosPurchLine: Record "Purch. Inv. Line";
                rec_ApproveEntry: Record "Approval Entry";
                rec_User: Record User;
                t_approve: array[10] of Code[20];
                rec_PosPurchLine2: Record "Purch. Inv. Line";
                rec_BankAccount: Record "Bank Account";
                rec_GenJournalLine: Record "Gen. Journal Line";
                d_totalAmount: Decimal;
            begin
                // get name bank account
                rec_BankAccount.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                if rec_BankAccount.FindFirst() then
                    t_NameBank := rec_BankAccount.Name;

                // get vendor or customer 
                rec_Customer.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Customer.FindFirst() then begin
                    t_NameCustomer := rec_Customer.Name;
                    t_AddressCustomer := rec_Customer.Address + rec_Customer."Address 2";
                end;
                rec_Vendor.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Vendor.FindFirst() then begin
                    t_NameCustomer := rec_Vendor.Name;
                    t_AddressCustomer := rec_Vendor.Address + rec_Vendor."Address 2";
                end;

                // get terbilang words dalam bahasa indonesia
                d_totalAmount := 0;
                rec_GenJournalLine.SetRange("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                rec_GenJournalLine.SetRange("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                if rec_GenJournalLine.FindFirst() then begin
                    repeat
                        d_totalAmount += rec_GenJournalLine."Amount (LCY)";
                        RepCheck.FormatNoText(arrray, d_totalAmount, '');
                        AmountInWords := arrray[1] + ' Rupiah';
                    until rec_GenJournalLine.Next = 0;
                end;

                // geta approval
                rec_ApproveEntry.SetRange("Document No.", "Gen. Journal Line"."Document No.");
                rec_ApproveEntry.SetRange(Status, rec_ApproveEntry.Status::Approved);
                if rec_ApproveEntry.FindFirst() then begin
                    repeat
                        i += 1;
                        t_approve[i] := rec_ApproveEntry."Approver ID";
                        d_ApproveDate[i] := rec_ApproveEntry."Last Date-Time Modified";
                        t_ApproveText[i] := 'APPROVED';
                        rec_User.SetRange("User Name", t_approve[i]);
                        if rec_User.FindFirst() then
                            t_ApproveName[i] := rec_User."Full Name";
                    until rec_ApproveEntry.Next = 0;
                end;
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInformasi.get;
        CompanyInformasi.CalcFields(Picture)
    end;

    var
        // g1
        CompanyInformasi: record "Company Information";
        //g2
        t_NameCustomer: Text;
        t_AddressCustomer: Text;
        // g3
        RepCheck: Codeunit "Saying Indonesia";
        AmountInWords: Text;
        arrray: array[1] of text;
        // g4
        d_DetailAmountLine: Decimal;
        t_DetailDescriptionLine: Text;
        i_rows: Integer;
        // g5
        i: Integer;
        t_ApproveName: array[10] of Text;
        t_ApproveText: array[10] of Text;
        t_ApproveTitle: array[10] of Text;
        d_ApproveDate: array[10] of DateTime;
        // g6
        t_NameBank: Text;
}