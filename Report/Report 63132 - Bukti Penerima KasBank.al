report 63132 "Bukti Penerima KasBank"
{
    // Caption = 'BKK Batch';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63132 - Bukti Penerima KasBank.rdlc';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;


    dataset
    {
        dataitem("Gen. Journal Line2"; "Gen. Journal Line")
        {
            column(GetCustomerCode; GetCustomerCode("Document No."))
            { }
            column(DirekturUtama; DirekturUtama)
            { }
            column(BuktiPendukung; BuktiPendukung)
            { }
            column(Line_No_Header; "Line No.") { }
            column(Journal_Batch_Name_Header; "Journal Batch Name") { }
            column(Document_No_Header; "Document No.") { }
            column(Applies_to_Doc__No_2; "Applies-to Doc. No.")
            {

            }
            column(Posting_Date_HEader; "Posting Date") { }
            column(Journal_Template_Name_header; "Journal Template Name") { }
            column(AmountInWords; text.UpperCase(AmountInWords)) { }
            column(d_totalAmount; d_totalAmount) { }
            column(DescriptionUpperCase; text.UpperCase(Description)) { }
            column(t_AddressCustomer; text.UpperCase(ShowCustomerAddress(GetCustomerCode("Document No.")))) { }
            column(t_NameCustomer; text.UpperCase(ShowCustomerName(GetCustomerCode("Document No.")))) { }
            // column(t_NameCustomer; text.UpperCase(t_NameCustomer)) { }
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

            dataitem("Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLink = "Document No." = field("Document No."), "Journal Batch Name" = field("Journal Batch Name"),
                "Journal Template Name" = field("Journal Template Name");
                column(Line_No_; "Line No.") { }
                column(PusatBiaya1; PusatBiaya("Dimension Set ID"))
                {

                }
                column(GetBankAccount; GetBankAccount(format("Account Type"), "Account No."))
                {

                }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {

                }
                column(GetAccountName; GetAccountName(format("Account Type"), "Account No."))
                { }
                // column(GetAccountName; acc)
                // { }
                column(no_urut; no_urut) { }
                column(Journal_Batch_Name; "Journal Batch Name") { }
                column(Account_No_; "Bal. Account No.") { }
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
                trigger OnPreDataItem()
                begin
                    // SetRange("Applies-to Doc. No.", '');
                    no_urut := LastNoPOInv;
                end;

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
                PuchInvLine: Record "Purch. Inv. Line";
                IncDocAttachment: Record "Inc. Doc. Attachment Overview";
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                DirekturUtama := GLSetup."Direktur Utama";
                if "Incoming Document Entry No." <> 0 then
                    BuktiPendukung := 'Terlampir'
                else
                    BuktiPendukung := 'Tidak Terlampir';
                LastNoPOInv := 0;
                PuchInvLine.Reset();
                PuchInvLine.SetRange("Document No.", "Applies-to Doc. No.");
                PuchInvLine.SetFilter(Type, '<> %1', PuchInvLine.Type::" ");
                if PuchInvLine.FindFirst() then
                    LastNoPOInv := PuchInvLine.Count;

                // get name bank account
                rec_BankAccount.SetRange("No.", "Account No.");
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
        // dataitem("Sales Invoice Line"; "Sales Invoice Line")
        // {

        //     column(PIVDescription; Description)
        //     {

        //     }
        //     column(PusatBiaya2; PusatBiaya2)
        //     {

        //     }
        //     column(DescAvaialable; DescAvaialable)
        //     {

        //     }
        //     column(PIVAmount_Including_VAT; AmountGenJnlLine)
        //     {

        //     }
        //     column(ShowAccountNo; ShowAccountNo)
        //     {

        //     }

        //     column(ShortcutDim2GenJnlLine; ShortcutDim2GenJnlLine)
        //     {

        //     }
        //     column(GetAccountNoformGL; GetAccountNoformGL)
        //     {

        //     }
        //     column(NoUrut2; NoUrut2)
        //     {

        //     }

        //     trigger OnPreDataItem()
        //     var
        //         GenJrnlLine: Record "Gen. Journal Line";
        //     begin
        //         NoUrut2 := 0;
        //         GetAccountNoformGL := '';
        //         SetRange("Document No.", "Gen. Journal Line2"."Applies-to Doc. No.");
        //         GenJrnlLine.Reset();
        //         GenJrnlLine.SetRange("Journal Batch Name", "Gen. Journal Line2"."Journal Batch Name");
        //         GenJrnlLine.SetRange("Journal Template Name", "Gen. Journal Line2"."Journal Template Name");
        //         GenJrnlLine.SetRange("Document No.", "Gen. Journal Line2"."Document No.");
        //         if GenJrnlLine.FindFirst() then begin
        //             NoUrut2 := "Gen. Journal Line2".Count;
        //             AmountGenJnlLine := "Gen. Journal Line2".Amount;
        //             ShortcutDim2GenJnlLine := "Gen. Journal Line2"."Shortcut Dimension 2 Code";
        //             GetAccountNoformGL := "Gen. Journal Line2"."Bal. Account No.";
        //             PusatBiaya2 := PusatBiaya("Gen. Journal Line2"."Dimension Set ID");
        //         end;
        //         // SetFilter("No.", '<> %1', '');
        //     end;

        //     trigger OnAfterGetRecord()
        //     begin
        //         NoUrut2 := NoUrut2 + 1;
        //         if Description = '' then
        //             DescAvaialable := false
        //         else
        //             DescAvaialable := true;
        //     end;

        // }

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
    local procedure GetCustomerCode(DocumentNo: Text): Text
    var
        GenJrnLine: Record "Gen. Journal Line";
    begin
        GenJrnLine.Reset();
        GenJrnLine.SetRange("Document No.", DocumentNo);
        GenJrnLine.SetRange("Account Type", GenJrnLine."Account Type"::Customer);
        if GenJrnLine.FindFirst() then
            exit(GenJrnLine."Account No.")
        else
            exit('');
    end;

    local procedure ShowCustomerAddress(CustCode: Text): Text
    var
        Customernya: Record Customer;
    begin
        Customernya.Reset();
        Customernya.SetRange("No.", CustCode);
        if Customernya.FindFirst() then
            exit(Customernya.Address + Customernya."Address 2")
        else
            exit('');
    end;

    local procedure ShowCustomerName(CustCode: Text): Text
    var
        Customernya: Record Customer;
    begin
        Customernya.Reset();
        Customernya.SetRange("No.", CustCode);
        if Customernya.FindFirst() then
            exit(Customernya.Name)
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
        PusatBiaya2: Text;
        DirekturUtama: Text;
        NoUrut2: Integer;
        CompanyInformasi: record "Company Information";
        GetAccountNoformGL: Text;
        DocumentNo: Text;
        DescAvaialable: Boolean;
        AmountGenJnlLine: Decimal;
        ShortcutDim2GenJnlLine: Text;
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




    local procedure PusatBiaya(DimensionSetID: Integer): Text
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        DimensionSetEntry.Reset();
        DimensionSetEntry.setrange("Dimension Set ID", DimensionSetID);
        DimensionSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
        if DimensionSetEntry.FindFirst() then
            exit(DimensionSetEntry."Dimension Value Code")
        else
            exit('');
    end;

    local procedure GetAccountName(AccountType: text; AccountCode: Text): Text
    var
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        VendorMaster: Record Vendor;
        CustomerMaster: Record Customer;
        EmployeeMaster: Record Employee;
        AssetMaster: Record "Fixed Asset";
        ShowName: Text;
    begin
        ShowName := '';
        if AccountType = 'G/L Account' then begin
            GLAccount.Reset();
            GLAccount.SetRange("No.", AccountCode);
            if GLAccount.FindFirst() then
                ShowName := GLAccount.Name;
        end else
            if AccountType = 'Bank Account' then begin
                BankAccount.Reset();
                BankAccount.SetRange("No.", AccountCode);
                if BankAccount.FindFirst() then
                    ShowName := BankAccount.Name;
            end else
                if AccountType = 'Vendor' then begin
                    VendorMaster.Reset();
                    VendorMaster.SetRange("No.", AccountCode);
                    if VendorMaster.FindFirst() then
                        ShowName := VendorMaster.Name;
                end else
                    if AccountType = 'Customer' then begin
                        CustomerMaster.Reset();
                        CustomerMaster.SetRange("No.", AccountCode);
                        if CustomerMaster.FindFirst() then
                            ShowName := CustomerMaster.Name;
                    end else
                        if AccountType = 'Employee' then begin
                            EmployeeMaster.Reset();
                            EmployeeMaster.SetRange("No.", AccountCode);
                            if EmployeeMaster.FindFirst() then
                                ShowName := EmployeeMaster.FullName();
                        end else
                            if AccountType = 'Fixed Asset' then begin
                                AssetMaster.Reset();
                                AssetMaster.SetRange("No.", AccountCode);
                                if AssetMaster.FindFirst() then
                                    ShowName := AssetMaster.Description;
                            end;
        exit(ShowName);

    end;

    local procedure GetBankAccount(AccountType: Text; AccountCode: Text): Text
    var
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        VendorMaster: Record Vendor;
        CustomerMaster: Record Customer;
        EmployeeMaster: Record Employee;
        AssetMaster: Record "Fixed Asset";
        BankAccPostingGrp: Record "Bank Account Posting Group";
        VendorAccPostingGrp: Record "Vendor Posting Group";
        CustomerAccPostingGrp: Record "Customer Posting Group";
        EmployeeAccPostingGrp: Record "Employee Posting Group";
        FAPostingGrp: Record "FA Posting Group";
        GlAccountNo: Text;
    begin
        // GlAccountNo := '-';
        if AccountType = 'Bank Account' then begin
            BankAccount.Reset();
            BankAccount.SetRange("No.", AccountCode);
            if BankAccount.FindFirst() then
                BankAccPostingGrp.Reset();
            BankAccPostingGrp.SetRange(Code, BankAccount."Bank Acc. Posting Group");
            if BankAccPostingGrp.FindFirst() then
                GlAccountNo := BankAccPostingGrp."G/L Account No.";
        end else
            if AccountType = 'Vendor' then begin
                VendorMaster.Reset();
                VendorMaster.SetRange("No.", AccountCode);
                if VendorMaster.FindFirst() then
                    VendorAccPostingGrp.Reset();
                VendorAccPostingGrp.SetRange(Code, VendorMaster."Vendor Posting Group");
                if VendorAccPostingGrp.FindFirst() then
                    GlAccountNo := VendorAccPostingGrp."Payables Account";
            end else
                if AccountType = 'Customer' then begin
                    CustomerMaster.Reset();
                    CustomerMaster.SetRange("No.", AccountCode);
                    if CustomerMaster.FindFirst() then
                        CustomerAccPostingGrp.Reset();
                    CustomerAccPostingGrp.SetRange(Code, CustomerMaster."Customer Posting Group");
                    if CustomerAccPostingGrp.FindFirst() then
                        GlAccountNo := CustomerAccPostingGrp."Receivables Account";
                end else
                    if AccountType = 'Employee' then begin
                        EmployeeMaster.Reset();
                        EmployeeMaster.SetRange("No.", AccountCode);
                        if EmployeeMaster.FindFirst() then
                            EmployeeAccPostingGrp.Reset();
                        EmployeeAccPostingGrp.SetRange(Code, EmployeeMaster."Employee Posting Group");
                        if EmployeeAccPostingGrp.FindFirst() then
                            GlAccountNo := EmployeeAccPostingGrp."Payables Account";
                    end else
                        if AccountType = 'Fixed Asset' then begin
                            AssetMaster.Reset();
                            AssetMaster.SetRange("No.", AccountCode);
                            if AssetMaster.FindFirst() then
                                FAPostingGrp.Reset();
                            FAPostingGrp.SetRange(Code, AssetMaster."FA Posting Group");
                            if FAPostingGrp.FindFirst() then
                                GlAccountNo := FAPostingGrp."Acquisition Cost Account";
                        end;
        exit(GlAccountNo);
    end;
}