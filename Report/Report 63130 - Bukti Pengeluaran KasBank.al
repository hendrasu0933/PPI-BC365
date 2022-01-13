report 63130 "Bukti Pengeluaran KasBank"
{
    Caption = 'BKK Batch';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63130 - Bukti Pengeluaran KasBank.rdlc';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;


    dataset
    {
        dataitem("Gen. Journal Line2"; "Gen. Journal Line")
        {
            column(Line_No_Header; "Line No.") { }
            column(Journal_Batch_Name_Header; "Journal Batch Name") { }
            column(Document_No_Header; "Document No.") { }
            column(Posting_Date_HEader; "Posting Date") { }
            column(Journal_Template_Name_header; "Journal Template Name") { }
            column(AmountInWords; text.UpperCase(AmountInWords)) { }
            column(d_totalAmount; d_totalAmount) { }
            column(DescriptionUpperCase; text.UpperCase("Message to Recipient")) { }
            column(t_AddressCustomer; text.UpperCase(t_AddressCustomer)) { }
            column(t_NameCustomer; text.UpperCase(t_NameCustomer)) { }
            column(External_Document_No_; "External Document No.") { }
            dataitem("Journal Line Document"; "Journal Line Document")
            {
                DataItemLink = "Document No." = field("Document No.");
                column(dd; "Journal Line Document".RecordId) { }
                column(i_MaxNumSequence; i_MaxNumSequence) { }
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
                column(Document_No_LineDoc; "Document No.") { }
                trigger OnAfterGetRecord()
                var
                    rec_ApproveEntry: Record "Approval Entry";
                    rec_ApproveEntryLast: Record "Approval Entry";
                    t_approve: array[10] of Code[20];
                    rec_User: Record User;
                    rec_JourLineDoc: Record "Journal Line Document";
                    awalApproveEntry: Integer;
                begin
                    // geta approval
                    awalApproveEntry := 0;
                    i_MaxNumSequence := 0;
                    if Status <> Status::Open then begin
                        rec_ApproveEntryLast.Reset();
                        rec_ApproveEntryLast.SetRange("Record ID to Approve", "Journal Line Document".RecordId);
                        if rec_ApproveEntryLast.FindLast() then begin

                            i_MaxNumSequence := rec_ApproveEntryLast."Sequence No.";
                            awalApproveEntry := rec_ApproveEntryLast."Entry No." - (i_MaxNumSequence - 1);

                            rec_ApproveEntry.Reset();
                            rec_ApproveEntry.SetRange("Record ID to Approve", "Journal Line Document".RecordId);
                            rec_ApproveEntry.SetRange("Entry No.", awalApproveEntry, rec_ApproveEntryLast."Entry No.");
                            if rec_ApproveEntry.FindFirst() then begin
                                repeat
                                    i += 1;
                                    if rec_ApproveEntry.Status = rec_ApproveEntry.Status::Approved then begin
                                        t_approve[i] := rec_ApproveEntry."Approver ID";
                                        d_ApproveDate[i] := rec_ApproveEntry."Last Date-Time Modified";
                                        t_ApproveText[i] := 'APPROVED';
                                        rec_User.SetRange("User Name", t_approve[i]);
                                        if rec_User.FindFirst() then
                                            t_ApproveName[i] := rec_User."Full Name";
                                    end else begin
                                        t_ApproveText[i] := '';
                                    end;
                                until rec_ApproveEntry.Next() = 0;
                            end;

                        end;
                        // rec_ApproveEntry.Reset();
                        // rec_ApproveEntry.SetRange("Record ID to Approve", "Journal Line Document".RecordId);
                        // if rec_ApproveEntry.FindLast() then begin
                        //     i_MaxNumSequence := rec_ApproveEntry."Sequence No.";
                        //     repeat
                        //         i += 1;
                        //         if rec_ApproveEntry.Status = rec_ApproveEntry.Status::Approved then begin
                        //             t_approve[i] := rec_ApproveEntry."Approver ID";
                        //             d_ApproveDate[i] := rec_ApproveEntry."Last Date-Time Modified";
                        //             t_ApproveText[i] := 'APPROVED';
                        //             rec_User.SetRange("User Name", t_approve[i]);
                        //             if rec_User.FindFirst() then
                        //                 t_ApproveName[i] := rec_User."Full Name";
                        //         end else begin
                        //             t_ApproveText[i] := '';
                        //         end;
                        //     until rec_ApproveEntry.Next(-1) = 0;
                        // end;
                    end;

                end;
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("Applies-to Doc. No.");
                column(PIVDescription; Description)
                {

                }
                column(PIVAmount_Including_VAT; "Amount Including VAT")
                {

                }
                column(ShowAccountNo; ShowAccountNo)
                {

                }

            }
            dataitem("Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLink = "Document No." = field("Document No."), "Journal Batch Name" = field("Journal Batch Name"),
                "Journal Template Name" = field("Journal Template Name");
                column(Line_No_; "Line No.") { }
                column(no_urut; no_urut) { }
                column(Journal_Batch_Name; "Journal Batch Name") { }
                column(Account_No_; "Account No.") { }
                column(Journal_Template_Name; "Journal Template Name") { }
                column(CompanyInformasi; CompanyInformasi.City) { }
                column(Posting_Date; "Posting Date") { }
                column(Credit_Amount; "Credit Amount") { }
                column(Debit_Amount; "Debit Amount") { }
                column(Amount; Amount) { }
                column(Amount__LCY_; "Amount (LCY)") { }
                column(Bal__Account_Type; "Bal. Account Type") { }
                column(Bal__Account_No_; "Bal. Account No.") { }
                column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
                column(Document_No_; "Document No.") { }
                column(Description; Description) { }
                column(t_NameBank; t_NameBank) { }
                column(i_rows; i_rows) { }
                trigger OnAfterGetRecord()
                begin
                    no_urut += 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
                rec_GenJournalLine: Record "Gen. Journal Line";
                d_ifAmountMin: Decimal;
                rec_Customer: Record Customer;
                rec_Vendor: Record Vendor;
                rec_PosPurchLine: Record "Purch. Inv. Line";
                rec_PosPurchLine2: Record "Purch. Inv. Line";
                rec_BankAccount2: Record "Bank Account";
                rec_BankAccount: Record "Bank Account";
            begin

                // get name bank account
                rec_BankAccount.SetRange("No.", "Bal. Account No.");
                if rec_BankAccount.FindFirst() then
                    t_NameBank := rec_BankAccount.Name;

                // get vendor or customer 
                rec_Customer.SetRange("No.", "Account No.");
                if rec_Customer.FindFirst() then begin
                    t_NameCustomer := rec_Customer.Name;
                    t_AddressCustomer := rec_Customer.Address + rec_Customer."Address 2";
                end;
                rec_Vendor.SetRange("No.", "Account No.");
                if rec_Vendor.FindFirst() then begin
                    t_NameCustomer := rec_Vendor.Name;
                    t_AddressCustomer := rec_Vendor.Address + rec_Vendor."Address 2";
                end;
                rec_BankAccount.SetRange("No.", "Account No.");
                if rec_BankAccount.FindFirst() then begin
                    t_NameCustomer := rec_BankAccount.Name;
                    t_AddressCustomer := rec_BankAccount.Address + rec_BankAccount."Address 2";
                end;

                // get terbilang words dalam bahasa indonesia
                d_totalAmount := 0;
                d_ifAmountMin := 0;
                rec_GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
                rec_GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
                rec_GenJournalLine.SetRange("Document No.", "Document No.");
                if rec_GenJournalLine.FindFirst() then begin
                    repeat
                        if rec_GenJournalLine."Amount (LCY)" < 0 then begin
                            d_ifAmountMin := 0;
                        end else begin
                            d_ifAmountMin := rec_GenJournalLine."Amount (LCY)";
                        end;
                        d_totalAmount += d_ifAmountMin;
                        RepCheck.FormatNoText(arrray, d_totalAmount, '');
                        AmountInWords := arrray[1] + ' Rupiah';
                    until rec_GenJournalLine.Next = 0;
                end;
            end;
        }
    }

    trigger OnInitReport()
    var
        GLJournal: Record "Gen. Journal Line";
    begin
        CompanyInformasi.get;
        CompanyInformasi.CalcFields(Picture);

    end;

    var
        // g1
        CompanyInformasi: record "Company Information";
        DocumentNo: Text;
        //g2
        t_NameCustomer: Text;
        t_AddressCustomer: Text;
        // g3
        RepCheck: Codeunit "Saying Indonesia";
        AmountInWords: Text;
        arrray: array[1] of text;
        // g4
        d_DetailAmountLine: Decimal;
        d_totalAmount: Decimal;
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
        dd: RecordId;
        no_urut: Integer;
        i_MaxNumSequence: Integer;
}