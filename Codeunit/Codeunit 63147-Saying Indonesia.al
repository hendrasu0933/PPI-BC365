codeunit 63147 "Saying Indonesia"
{

    Permissions = TableData 17 = rm,
                  TableData 45 = rimd,
                  TableData 113 = rimd,
                  TableData 121 = rimd,
                  TableData 380 = rm,
                  TableData 5601 = rmd;

    trigger OnRun();
    begin
    end;

    var
        Text026: Label 'Nol';
        Text027: Label 'Ratus';
        Text032: Label 'Satu';
        Text033: Label 'Dua';
        Text034: Label 'Tiga';
        Text035: Label 'Empat';
        Text036: Label 'Lima';
        Text037: Label 'Enam';
        Text038: Label 'Tujuh';
        Text039: Label 'Delapan';
        Text040: Label 'Sembilan';
        Text041: Label 'Sepuluh';
        Text042: Label 'Sebelas';
        Text043: Label 'Dua Belas';
        Text044: Label 'Tiga Belas';
        Text045: Label 'Empat Belas';
        Text046: Label 'Lima Belas';
        Text047: Label 'Enam Belas';
        Text048: Label 'Tujuh Belas';
        Text049: Label 'Delapan Belas';
        Text050: Label 'Sembilan Belas';
        Text051: Label 'Dua Puluh';
        Text052: Label 'Tiga Puluh';
        Text053: Label 'Empat Puluh';
        Text054: Label 'Lima Puluh';
        Text055: Label 'Enam Puluh';
        Text056: Label 'Tujuh Puluh';
        Text057: Label 'Delapan Puluh';
        Text058: Label 'Sembilan Puluh';
        Text059: Label 'Ribu';
        Text060: Label 'Juta';
        Text061: Label 'Milyar';
        Text028: Label 'Dan';
        Text029: Label '%1 results in a written number that is too long.';
        Text062: Label 'Sepuluh';
        Text063: Label 'Seratus';
        Text064: Label 'Seribu';
        Text065: Label 'Sejuta';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        HundredsText: array[5] of Text[30];
        ExponentText: array[5] of Text[30];
        NumberText: array[2] of Text[250];

    procedure FormatNoText(var NoText: array[2] of Text[250]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Hundreds = 1 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text063);
                END;

                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF (Ones > 0) AND (Ones < 10) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    IF Ones = 10 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text062);
                END ELSE
                    IF ((Tens * 10 + Ones) = 1) AND (Exponent = 2) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, 'Seribu')
                    ELSE
                        IF (Tens * 10 + Ones) > 0 THEN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN BEGIN
                    IF NOT (((Tens * 10 + Ones) = 1) AND (Exponent = 2)) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                END;
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        //AddToNoText(NoText,NoTextIndex,PrintExponent,Text028);
        //AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    procedure AddToNoText(var NoText: array[2] of Text[250]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + '  ' + AddText, '<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;
        TensText[10] := Text062;

        HundredsText[1] := '';
        HundredsText[2] := Text027;
        HundredsText[3] := Text063;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure SplitText(var Bilangan1: Text[250]; var Bilangan2: Text[250]; Bilangan: Text[250]; Limit: Integer);
    var
        Pecahan: Decimal;
        SubStrLen: Integer;
        StrTemp: Text[250];
        Pos: Integer;
    begin
        Bilangan1 := Bilangan;
        Bilangan1 := DELCHR(Bilangan1, '=', '*');
        IF Bilangan1[1] = ' ' THEN
            Bilangan1 := DELSTR(Bilangan1, 1, 1);

        IF STRLEN(Bilangan1) > Limit THEN BEGIN
            StrTemp := Bilangan1;
            Pos := STRPOS(StrTemp, ' ');
            StrTemp := COPYSTR(StrTemp, Pos + 1);
            REPEAT
                SubStrLen := SubStrLen + Pos;
                Pos := STRPOS(StrTemp, ' ');
                StrTemp := COPYSTR(StrTemp, Pos + 1);
            UNTIL ((SubStrLen + Pos) >= Limit) OR (Pos = 0);
            Bilangan2 := COPYSTR(Bilangan1, SubStrLen + 1);
            Bilangan1 := COPYSTR(Bilangan1, 1, SubStrLen);
        END;
    end;

    procedure FormatNoTextWithFraction(var BilanganDgnPecahan: Text[250]; Bilangan: array[2] of Text[250]; Amount: Decimal; CurrencyCode: Code[10]);
    var
        Pecahan: Decimal;
        BilanganPecahan: array[2] of Text[250];
    begin
        IF Amount = 0 THEN
            ERROR('Amount tidak boleh bernilai 0');
        BilanganDgnPecahan := Bilangan[1] + ' ' + Bilangan[2];
        Pecahan := Amount MOD ROUND(Amount, 1, '<');
        Pecahan := Pecahan * 100;
        IF Pecahan <> 0 THEN BEGIN
            FormatNoText(BilanganPecahan, Pecahan, CurrencyCode);
            BilanganDgnPecahan := BilanganDgnPecahan + ' ' + BilanganPecahan[1] + BilanganPecahan[2];
        END;
    end;



    procedure GetCurrencySymbol(CurrencyCode: Code[10]): Text;
    var
        _Currency: Record 4;
    begin
        IF _Currency.GET(CurrencyCode) THEN
            IF _Currency.Symbol <> '' THEN
                EXIT(_Currency.Symbol)
            ELSE
                EXIT(CurrencyCode)
        ELSE
            EXIT('Rp');
    end;

    procedure MakeCamelCaseText(_Text: Text): Text
    var
        i: Integer;
        _CaseNya: Text;
    begin
        _Text := LOWERCASE(_Text);
        FOR i := 1 TO STRLEN(_Text) DO BEGIN
            IF (i = 1) AND (COPYSTR(_Text, i, 1) <> ' ') THEN BEGIN
                _CaseNya := UPPERCASE(COPYSTR(_Text, 1, 1));
                _Text := DELSTR(_Text, 1, 1);
                _Text := INSSTR(_Text, _CaseNya, 1);
            END ELSE
                IF COPYSTR(_Text, i, 1) = ' ' THEN BEGIN
                    IF (COPYSTR(_Text, i + 1, 1) <> ' ') OR (COPYSTR(_Text, i + 1, 1) <> '') THEN BEGIN
                        _CaseNya := UPPERCASE(COPYSTR(_Text, i + 1, 1));
                        _Text := DELSTR(_Text, i + 1, 1);
                        _Text := INSSTR(_Text, _CaseNya, i + 1);
                    END;
                END;
        END;
        EXIT(_Text);
    end;
}