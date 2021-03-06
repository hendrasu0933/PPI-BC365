report 63133 "Bukti Pengeluaran KasBank2"
{
    Caption = 'Bukti Pengeluaran KasBank';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63130 - Bukti Pengeluaran KasBank.rdlc';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;


    dataset
    {
        dataitem("Gen. Journal Line2"; "G/L Entry")
        {
            column(DirekturUtama; DirekturUtama)
            { }
            column(BuktiPendukung; BuktiPendukung)
            { }

            // column(Line_No_Header; "Line No.") { }
            column(Journal_Batch_Name_Header; "Journal Batch Name") { }
            column(Document_No_Header; "Document No.") { }
            // column(Applies_to_Doc__No_2; "Applies-to Doc. No."){}
            column(Posting_Date_HEader; "Posting Date") { }
            // column(Journal_Template_Name_header; "Journal Template Name") { }
            column(AmountInWords; text.UpperCase(AmountInWords)) { }
            column(d_totalAmount; d_totalAmount) { }
            // column(DescriptionUpperCase; text.UpperCase("Message to Recipient")) { }
            column(DescriptionUpperCase; text.UpperCase(Description)) { }
            column(t_AddressCustomer; text.UpperCase(t_AddressCustomer)) { }
            column(t_NameCustomer; text.UpperCase(t_NameCustomer)) { }
            column(External_Document_No_; "External Document No.") { }
            column(GetBankAccount; "G/L Account No.")
            {

            }
            column(no_urut; no_urut) { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Account_No_; "G/L Account No.") { }
            // column(Journal_Template_Name; "Journal Template Name") { }
            column(CompanyInformasi; CompanyInformasi.City) { }
            column(Posting_Date; "Posting Date") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Amount; Amount) { }
            // column(Amount__LCY_; "Amount (LCY)") { }
            column(Bal__Account_Type; "Bal. Account Type") { }
            column(Bal__Account_No_; "Bal. Account No.") { }
            // column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
            column(Document_No_; "Document No.") { }
            column(Description; Description) { }
            column(t_NameBank; t_NameBank) { }
            column(i_rows; i_rows) { }

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

            trigger OnPreDataItem()
            var

                PuchInvLine: Record "Purch. Inv. Line";
            begin

                LastNo_urut := 0;

            end;

            trigger OnAfterGetRecord()
            var

                rec_GenJournalLine: Record "G/L Entry";
                d_ifAmountMin: Decimal;
                rec_Customer: Record Customer;
                rec_Vendor: Record Vendor;
                rec_PosPurchLine: Record "Purch. Inv. Line";
                rec_PosPurchLine2: Record "Purch. Inv. Line";
                rec_BankAccount2: Record "Bank Account";
                rec_BankAccount: Record "Bank Account";
                PuchInvLine: Record "Purch. Inv. Line";
                IncDocAttachment: Record "Inc. Doc. Attachment Overview";
                No_urut2: Integer;
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                DirekturUtama := GLSetup."Direktur Utama";
                IncDocAttachment.Reset();
                IncDocAttachment.SetRange("Document No.", "Document No.");
                IncDocAttachment.SetRange("Posting Date", "Posting Date");
                if IncDocAttachment.FindFirst() then
                    BuktiPendukung := 'Terlampir'
                else
                    BuktiPendukung := 'Tidak Terlampir';

                InvNo := getInvNo("Gen. Journal Line2"."Transaction No.");

                LastNoPOInv := 0;
                PuchInvLine.Reset();
                PuchInvLine.SetRange("Document No.", InvNo);
                PuchInvLine.SetFilter(Type, '<> %1', PuchInvLine.Type::" ");
                if PuchInvLine.FindFirst() then
                    LastNoPOInv := PuchInvLine.Count;
                No_urut2 := LastNoPOInv;
                No_urut2 += 1;

                if LastNo_urut = 0 then
                    no_urut := No_urut2
                else
                    no_urut := LastNo_urut + 1;

                LastNo_urut := no_urut;

                // get name bank account
                rec_BankAccount.SetRange("No.", "Bal. Account No.");
                if rec_BankAccount.FindFirst() then
                    t_NameBank := rec_BankAccount.Name;

                // get vendor or customer 
                rec_Customer.SetRange("No.", "Source No.");
                if rec_Customer.FindFirst() then begin
                    t_NameCustomer := rec_Customer.Name;
                    t_AddressCustomer := rec_Customer.Address + rec_Customer."Address 2";
                end;
                rec_Vendor.SetRange("No.", "Source No.");
                if rec_Vendor.FindFirst() then begin
                    t_NameCustomer := rec_Vendor.Name;
                    t_AddressCustomer := rec_Vendor.Address + rec_Vendor."Address 2";
                end;
                rec_BankAccount.SetRange("No.", "Source No.");
                if rec_BankAccount.FindFirst() then begin
                    t_NameCustomer := rec_BankAccount.Name;
                    t_AddressCustomer := rec_BankAccount.Address + rec_BankAccount."Address 2";
                end;

                // get terbilang words dalam bahasa indonesia
                d_totalAmount := 0;
                d_ifAmountMin := 0;
                // rec_GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
                rec_GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
                rec_GenJournalLine.SetRange("Document No.", "Document No.");
                if rec_GenJournalLine.FindFirst() then begin
                                                           repeat
                                                               if rec_GenJournalLine.Amount < 0 then begin
                                                                   d_ifAmountMin := 0;
                                                               end else begin
                                                                   d_ifAmountMin := rec_GenJournalLine.Amount;
                                                               end;
                                                               d_totalAmount += d_ifAmountMin;
                                                               RepCheck.FormatNoText(arrray, d_totalAmount, '');
                                                               AmountInWords := arrray[1] + ' Rupiah';
                                                           until rec_GenJournalLine.Next = 0;
                end;
            end;
        }
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            column(ShowVendorName; ShowVendorName("Buy-from Vendor No."))
            {

            }
            column(PIVDescription; Description)
            {

            }
            column(DescAvaialable; DescAvaialable)
            {

            }
            column(PIVAmount_Including_VAT; "Amount Including VAT")
            {

            }
            column(ShowAccountNo; ShowAccountNo)
            {

            }
            column(GLShortcut_Dimension_2_Code; GetShortcutDimension2formGL)
            {

            }
            column(GetAccountNoformGL; GetAccountNoformGL)
            { }
            // column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            // {

            // }

            trigger OnPreDataItem()
            var
                GenJrnlLine: Record "Gen. Journal Line";
            begin
                GetShortcutDimension2formGL := "Gen. Journal Line2"."Global Dimension 2 Code";
                GetAccountNoformGL := "Gen. Journal Line2"."G/L Account No.";
                InvNo := getInvNo("Gen. Journal Line2"."Transaction No.");
                // Message('%1', InvNo);
                SetRange("Document No.", InvNo);
                // GenJrnlLine.Reset();
                // GenJrnlLine.SetRange("Journal Batch Name", "Gen. Journal Line2"."Journal Batch Name");
                // GenJrnlLine.SetRange("Journal Template Name", "Gen. Journal Line2"."Journal Template Name");
                // GenJrnlLine.SetRange("Document No.", "Gen. Journal Line2"."Document No.");
                // if GenJrnlLine.FindFirst() then begin
                //     GetShortcutDimension2formGL := GenJrnlLine."Shortcut Dimension 2 Code";
                //     GetAccountNoformGL := GenJrnlLine."Account No.";
                // end;
                // SetFilter("No.", '<> %1', '');
            end;

            trigger OnAfterGetRecord()
            begin
                if Description = '' then
                    DescAvaialable := false
                else
                    DescAvaialable := true;
            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(control123)
                {
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = all;
                        TableRelation = "Gen. Journal Line"."Document No.";
                        Visible = false;

                    }
                }
            }
        }
    }

    local procedure getInvNo(TransactionNo: Integer): Text
    var
        VendorLedger: Record "Vendor Ledger Entry";
        DetailedVendorLedger: Record "Detailed Vendor Ledg. Entry";
        VendorLedger2: Record "Vendor Ledger Entry";
        InvNonya: Text;
    begin
        VendorLedger.Reset();
        VendorLedger.SetRange("Transaction No.", transactionNo);
        if VendorLedger.FindFirst() then begin
            VendorLedger2.Reset();
            VendorLedger2.SetRange("Closed by Entry No.", VendorLedger."Entry No.");
            if VendorLedger2.FindFirst() then begin
                InvNonya := format(VendorLedger2."Document No.");
            end;
        end;
        exit(InvNonya);
    end;

    local procedure ShowVendorName(VendCode: Text): Text
    var
        Vendornya: Record Vendor;
    begin
        Vendornya.Reset();
        Vendornya.SetRange("No.", VendCode);
        if Vendornya.FindFirst() then
            exit(Vendornya.Name)
        else
            exit('');
    end;


    trigger OnInitReport()
    var
        GLJournal: Record "Gen. Journal Line";
    begin
        CompanyInformasi.get;
        CompanyInformasi.CalcFields(Picture);

    end;

    var
        // g1
        DirekturUtama: Text;
        LastNo_urut: Integer;
        CompanyInformasi: record "Company Information";
        DocumentNo: Text;
        GetShortcutDimension2formGL: Text;
        GetAccountNoformGL: Text;
        DescAvaialable: Boolean;
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
        LastNoPOInv: Integer;
        BuktiPendukung: Text;
        InvNo: Text;

    local procedure GetBankAccount(AccountType: Text; BankCode: Text): Text
    var
        BankAccount: Record "Bank Account";
        BankAccPostingGrp: Record "Bank Account Posting Group";
        GlAccount: Text;
    begin
        GlAccount := '-';
        if AccountType = 'Bank Account' then begin
            BankAccount.Reset();
            BankAccount.SetRange("No.", BankCode);
            if BankAccount.FindFirst() then
                BankAccPostingGrp.Reset();
            BankAccPostingGrp.SetRange(Code, BankAccount."Bank Acc. Posting Group");
            if BankAccPostingGrp.FindFirst() then
                GlAccount := BankAccPostingGrp."G/L Account No.";
        end;
        exit(GlAccount);
    end;
}