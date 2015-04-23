function GetWrapedText(text, maxlength) {
    var resultText = [""];
    var len = text.length;
    if (maxlength >= len) {
        return text;
    }
    else {
        var totalStrCount = parseInt(len / maxlength);
        if (len % maxlength != 0) {
            totalStrCount++
        }

        for (var i = 0; i < totalStrCount; i++) {
            if (i == totalStrCount - 1) {
                resultText.push(text);
            }
            else {
                var strPiece = text.substring(0, maxlength - 1);
                resultText.push(strPiece);
                resultText.push("<br>");
                text = text.substring(maxlength - 1, text.length);
            }
        }
    }
    return resultText.join("");
}
