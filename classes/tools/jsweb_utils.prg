#INCLUDE json-fox.h

* Version 1.3.2

DEFINE CLASS WebUtils AS Custom

    FUNCTION UrlEncode(tcString)
        LOCAL lcEncoded, lnChar, lcChar, lcHex

        lcEncoded = ""
        FOR lnChar = 1 TO LEN(tcString)
            lcChar = SUBSTR(tcString, lnChar, 1)
            DO CASE
                CASE lcChar $ "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"
                    lcEncoded = lcEncoded + lcChar
                OTHERWISE
                    lcHex = TRANSFORM(ASC(lcChar), "@0")
                    lcEncoded = lcEncoded + "%" + lcHex
            ENDCASE
        ENDFOR

        RETURN lcEncoded
    ENDFUNC

    FUNCTION UrlDecode(tcString)
        LOCAL lcDecoded, lnChar, lcChar, lcHex

        lcDecoded = ""
        lnChar = 1
        DO WHILE lnChar <= LEN(tcString)
            lcChar = SUBSTR(tcString, lnChar, 1)
            IF lcChar == "%"
                lcHex = SUBSTR(tcString, lnChar + 1, 2)
                lcDecoded = lcDecoded + CHR(VAL("0x" + lcHex))
                lnChar = lnChar + 2
            ELSE
                lcDecoded = lcDecoded + lcChar
            ENDIF
            lnChar = lnChar + 1
        ENDDO

        RETURN lcDecoded
    ENDFUNC

    FUNCTION ParseUrl(tcUrl)
        LOCAL loUrlParts, lcProtocol, lcHost, lcPath, lcQueryString, lcFragment, lnPos

        loUrlParts = CREATEOBJECT("Empty")
        ADDPROPERTY(loUrlParts, "Protocol", "")
        ADDPROPERTY(loUrlParts, "Host", "")
        ADDPROPERTY(loUrlParts, "Path", "")
        ADDPROPERTY(loUrlParts, "QueryString", "")
        ADDPROPERTY(loUrlParts, "Fragment", "")

        * Extract protocol
        lnPos = AT("://", tcUrl)
        IF lnPos > 0
            loUrlParts.Protocol = LEFT(tcUrl, lnPos - 1)
            tcUrl = SUBSTR(tcUrl, lnPos + 3)
        ENDIF

        * Extract fragment
        lnPos = AT("#", tcUrl)
        IF lnPos > 0
            loUrlParts.Fragment = SUBSTR(tcUrl, lnPos + 1)
            tcUrl = LEFT(tcUrl, lnPos - 1)
        ENDIF

        * Extract query string
        lnPos = AT("?", tcUrl)
        IF lnPos > 0
            loUrlParts.QueryString = SUBSTR(tcUrl, lnPos + 1)
            tcUrl = LEFT(tcUrl, lnPos - 1)
        ENDIF

        * Extract host and path
        lnPos = AT("/", tcUrl)
        IF lnPos > 0
            loUrlParts.Host = LEFT(tcUrl, lnPos - 1)
            loUrlParts.Path = SUBSTR(tcUrl, lnPos)
        ELSE
            loUrlParts.Host = tcUrl
        ENDIF

        RETURN loUrlParts
    ENDFUNC

ENDDEFINE