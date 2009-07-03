// compatibility mode
jQuery.noConflict();


jQuery(document).ready(function() {
	THCTagCore.addRightClickImageHooks();
});

THCTag = {
    // return XPointer from current selection
    getXPointerFromSelection: function() {
        var result = THCTagCore.XPath.getXPointerFromSelection();
        THCTagUtil.writeMessage("selection", result);
        THCTagCore.setUserSelection(null);
        return result;
    },

    // add THCTag by XPointer
    addByXPointer: function(xpointer) {
        var splittedXPointer = THCTagCore.xPointerToXPath(xpointer);

        this.addByXPath(splittedXPointer[0][0], splittedXPointer[0][1],
            splittedXPointer[1][0], splittedXPointer[1][1]);
    },

    // add THCTag by XPath
    addByXPath: function(startXPath, startOffset, endXPath, endOffset) {
        if(!(startXPath == endXPath) || !(startOffset >= endOffset)) {
        	THCTagCore.Annotate.addTHCTagsFromXPath(startXPath, startOffset, endXPath, endOffset);    
        }
  
    },

    // show annotation
    show: function(startXPath, startOffset, endXPath, endOffset) {
        THCTagUtil.writeMessage("focus", THCTagCore.XPath.getXPointerString(startXPath, startOffset, endXPath, endOffset));
        THCTagCore.Annotate.showNoteById(startXPath, startOffset, endXPath, endOffset);
    },

    hide: function() {
        THCTagUtil.writeMessage("lost_focus", null);
    }
};

var userSelection;

THCTagCore = {
    // get start container
    getStartContainer: function() {
        var range = THCTagCore.getSelectedRange();
        return range.startContainer;
    },

    // get start offset
    getStartOffset: function() {
        var range = THCTagCore.getSelectedRange();
        return range.startOffset;
    },

    // get end container
    getEndContainer: function() {
        var range = THCTagCore.getSelectedRange();
        return range.endContainer;
    },

    // get end offset
    getEndOffset: function() {
        var range = THCTagCore.getSelectedRange();
        return range.endOffset;
    },

    // get selected text
    getSelectedRange: function() {
    
    	var result;
    
    	if (userSelection==null) {
    
        	if (window.getSelection)
        	{
            	result = window.getSelection().getRangeAt(0);
        	}
        	else if (document.getSelection)
        	{
            	result = document.getSelection().getRangeAt(0);
        	}
        	else if (document.selection)
        	{
            	result = document.selection.createRange();
        	}
            
        } else {
        
        	result = userSelection;
        	
        }    
      
        return result;
    },

	addRightClickImageHooks: function() {

		var imgTags = document.getElementsByTagName('img');
		
		for (var i = 0; i < imgTags.length; i++) {  
			imgTags[i].setAttribute('onMouseDown','THCTagCore.setUserSelection(THCTagCore.getRangeFromTag(this));');
		}; 
	},

	getRangeFromTag: function(el) {
		
		var range = document.createRange();
		range.selectNode(el);
		
		return range;
		
	},

	setUserSelection: function(s) {
	
		userSelection = s;
		
	},

    // check if element is an THCNote
    isTHCNote: function(e) {
        if((e.nodeName == "A")  && (e.getAttribute("name") == "THCLinkButton"))
            return true;

        if((e.nodeName == "IMG")  && (e.getAttribute("class") == "THCLinkButton"))
            return true;


        return false;
    },

    isTHCTagSplitterText: function(node) {

        if(node.nodeType == Node.ELEMENT_NODE) {
            // check if current node is a THC tag
            if ((node.nodeName == "A") && (node.getAttribute("name") == "THCLinkButton")) {
                var previous = node.previousSibling;
                var next = node.nextSibling;

                // check if there are text() items before and after of the THC tag
                if ((previous != null) && (next != null) && (previous.nodeType == Node.TEXT_NODE) && (next.nodeType == Node.TEXT_NODE)) {
                    return true;
                }
            }
        }

        return false;
    },

    xPointerToXPath: function(xpointer) {
        var startXPath = "";
        var startOffset = -1;
        var endXPath = "";
        var endOffset = -1;

        var splittedString = xpointer.split("#xpointer(start-point(string-range(")[1];
        splittedString = splittedString.split("))/range-to(string-range(");

        startXPath = splittedString[0].split(",")[0];
        startOffset = splittedString[0].split(",")[2];

        splittedString = splittedString[1].substr(0, splittedString[1].length - 3);

        endXPath = splittedString.split(",")[0];
        endOffset = splittedString.split(",")[2];

        return [[startXPath, startOffset], [endXPath, endOffset]];
    }

};

THCTagCore.XPath = {

    // get XPointer from current selection
    getXPointerFromSelection: function() {
        // return if there isn't a selection
        //if(THCTagCore.getSelectedText() == "") return null;
		
        // get selected node and offset
        var startContainer 	= THCTagCore.getStartContainer();
        var startOffset 	= THCTagCore.getStartOffset();
        var endContainer 	= THCTagCore.getEndContainer();
        var endOffset 		= THCTagCore.getEndOffset();

        // recostruct the XPath from THC_Tag
        var startXPath 	= this.getXPath(startContainer, "THCTag");
        var endXPath 	= this.getXPath(endContainer, "THCTag");

        // translate current pointer to original document pointer
        var startPoint = THCTagCore.XPathTranslator.tranlsateXPathToOriginal(startXPath, startOffset, 'forward');
        var endPoint = THCTagCore.XPathTranslator.tranlsateXPathToOriginal(endXPath, endOffset, 'backward');

        startXPath = startPoint[0];
        startOffset = startPoint[1];
        endXPath = endPoint[0];
        endOffset = endPoint[1];

        // create xpointer string
        var result = this.getXPointerString(startXPath, startOffset, endXPath, endOffset);
		
        return result;
    },

    getXPointerString: function(startXPath, startOffset, endXPath, endOffset) {
        return window.location.href
        + "#xpointer(start-point(string-range(" + startXPath + ",''," + startOffset + "))"
        + "/range-to(string-range(" + endXPath + ",''," + endOffset + ")))";
    },

    // get XPath from element
    // if a div with name='tag_name' is found, return relative XPath
    getXPath: function(e, tag_name) {
        return this.getXPathAcc(e, tag_name, null);
    },

    // getXPath with accumulator
    getXPathAcc: function(e, tag_name, acc) {
        if (!e) {
            // return XPath
            return acc;
        } else {
            // get node name
            var nodeName = this.getNodeName(e);

            // if tag is an element
            if (e.nodeType == Node.ELEMENT_NODE) {
                // if tag_name is found
                if (e.getAttribute('class') == tag_name) {
                    if (acc != null)
                        return "//DIV[@id = '" + e.getAttribute('id') + "']/" + acc;
                    else
                        return "//DIV[@id = '" + e.getAttribute('id') + "']";
                }

                // if BODY tag is found
                if (nodeName == "BODY" || nodeName == "HTML") {
                    if (acc != null)
                        return "//BODY/" + acc;
                    else
                        return "//BODY";
                }
            }

            // set new accumulator value (remove text() item from xpath)
            if (acc != null)
                acc = nodeName + "[" + this.getPreviousSiblingNodeWithSameName(e) + "]/" + acc;
            else
                acc = nodeName + "[" + this.getPreviousSiblingNodeWithSameName(e) + "]";

            // recursive call
            return this.getXPathAcc(e.parentNode, tag_name, acc);
        }
    },

    getPreviousSiblingNodeWithSameName: function(e) {
        var tag_name = e.nodeName;
        return this.getPreviousSiblingNodeWithSameNameAcc(e, tag_name, 1);
    },

    getPreviousSiblingNodeWithSameNameAcc: function(e, tag_name, counter) {
        // get previous sibling node
        var psNode = e.previousSibling;

        // if there is a previous sibling node
        if (!psNode) {
            // return counter
            return counter;
        } else {
            // previous sibling node has same name of current node, increment counter
            if ((psNode.nodeName == tag_name) && (!THCTagCore.isTHCNote(psNode))) {
                counter++;
            }

            // recursive call
            return this.getPreviousSiblingNodeWithSameNameAcc(psNode, tag_name, counter);
        }
    },

    // get node name
    getNodeName: function(e) {
        switch (e.nodeType) {
            case Node.ELEMENT_NODE:
                return e.nodeName;
                break;
            case Node.TEXT_NODE:
                return "text()";
                break;
        }
    }
};

THCTagCore.Annotate = {

    // get previous sibling node text length
    getPreviousSiblingNodeTextLenght: function(e) {
        return this.getPreviousSiblingNodeTextLenghtAcc(e, 0);
    },

    // get previous sibling node text length
    getPreviousSiblingNodeTextLenghtAcc: function(e, currentLength) {
        // get previous sibling node
        var psNode = e.previousSibling;
        // if there is a previous sibling node
        if (!psNode) {
            // return current lenght
            return currentLength;
        } else {
            if(psNode.nodeType == Node.TEXT_NODE) {
                currentLength += psNode.nodeValue.length;
            }

            return this.getPreviousSiblingNodeTextLenghtAcc(psNode, currentLength);
        }
    },

    addTHCTagsFromXPath: function(startXPath, startOffset, endXPath, endOffset) {
        // get name for note
        var elementId = THCTagCore.XPath.getXPointerString(startXPath, startOffset, endXPath, endOffset);

        // check if note tag is already present
        if (document.getElementById(elementId)) {
            //alert("Annotation already present.");
            return;
        }

        this.replaceEndNode(startXPath, startOffset, endXPath, endOffset, elementId);
    },

    replaceEndNode: function(startXPath, startOffset, endXPath, endOffset, elementName) {
        var endNode = null;

        // recalculate end node position
        var recalculatedEndPosition = THCTagCore.XPathTranslator.tranlsateXPathToCurrent(endXPath,endOffset);

        // get offset
        var endXPathLocal = recalculatedEndPosition[0];
        var endOffsetLocal = recalculatedEndPosition[1];

        // split xpath string by '/'
        var splittedXPathArray = endXPathLocal.split("/");

        // get last item from splitted XPath Array
        var lastItem = splittedXPathArray[splittedXPathArray.length - 1];
        lastItem = lastItem.toLowerCase();

        // if last item is a text, insert annotation into text
        // else insert after element tag
        if ((lastItem.substr(0,6) == "text()") || (lastItem.substr(0,5) == "#text")) {
            // get old text node
            var oldText = this.getTextFromXPath(endXPathLocal);

            // create new node
            var firstPart = document.createTextNode(oldText.substring(0, endOffsetLocal));
            var secondPart = this.selectionLinkButton(elementName, startXPath, startOffset, endXPath, endOffset);
            var thirdPart = document.createTextNode(oldText.slice(endOffsetLocal));

            var endNodes = document.evaluate(endXPathLocal, document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
            endNode = endNodes.snapshotItem(0);

            var endParentElement = endNode.parentNode;

            endParentElement.replaceChild(thirdPart, endNode);
            endParentElement.insertBefore(secondPart, thirdPart);
            endParentElement.insertBefore(firstPart, secondPart);
        } else {
            // get last node
            var lastNode = THCTagCore.XPathTranslator.getNodeAt(endXPathLocal, endOffsetLocal);
            lastNode = lastNode[0] + "[" + lastNode[1] + "]";
            endXPathLocal = [endXPathLocal, lastNode].join("/");

            // get old node
            endNode = document.evaluate(endXPathLocal, document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
            endNode = endNode.snapshotItem(0);

            var annotationNode = this.selectionLinkButton(elementName, startXPath, startOffset, endXPath, endOffset);
            var parentNode = endNode.parentNode;
            parentNode.replaceChild(annotationNode, endNode);
            parentNode.insertBefore(endNode, annotationNode);
        }
    },

    startNodeTag: function(elementName) {
        var startNodeTag = document.createElement("span");
        startNodeTag.setAttribute("name", elementName);
        startNodeTag.setAttribute("class", "THCNoteStart");

        return startNodeTag;
    },

    endNodeTag: function(elementName) {
        var endNodeTag = document.createElement("span");
        endNodeTag.setAttribute("name", elementName);
        endNodeTag.setAttribute("class", "THCNoteEnd");

        return endNodeTag;
    },

    selectionLinkButton: function(elementName, startXPath, startOffset, endXPath, endOffset) {
        var selectionLink = document.createElement("a");
        selectionLink.setAttribute("id", elementName);
        selectionLink.setAttribute("name", "THCLinkButton");
        selectionLink.setAttribute("class", "THCLinkButton");
        selectionLink.setAttribute("href", "#");
        selectionLink.setAttribute("style", "position:relative; margin:1px;");

        selectionLink.setAttribute("onClick", "THCTag.show(\"" + startXPath + "\", " + startOffset + ", \"" + endXPath + "\" , " + endOffset + ");return false;");
        var imageIcon = document.createElement("img");
        imageIcon.setAttribute("src", "/images/annotation.png");
        imageIcon.setAttribute("alt", "[Note]");
        imageIcon.setAttribute("style", "border:none;");
        selectionLink.appendChild(imageIcon);

        return selectionLink;
    },

    getTextNodeFromOffset: function(e, offset) {
        var currentNodeIndex = 1;

        var textNodes = document.evaluate(e + "/text()", document, null, XPathResult.ANY_TYPE, null);
        var currentNode = textNodes.iterateNext();

        while (currentNode) {
            if (currentNode.textContent) {
                offset -= currentNode.textContent.length;
            }

            if (offset > 0) {
                currentNode = textNodes.iterateNext();
                currentNodeIndex += 1;
            } else {
                currentNode = null;
            }
        }

        return "text()[" + currentNodeIndex + "]";
    },

    getLocalOffset: function(e, offset) {
        var currentOffset = offset;

        var textNodes = document.evaluate(e + "/child::text()", document, null, XPathResult.ANY_TYPE, null);
        var currentNode = textNodes.iterateNext();

        while (currentNode) {
            if (currentNode.textContent) {
                offset -= currentNode.nodeValue.length;
            }

            if (offset > 0) {
                currentNode = textNodes.iterateNext();
                currentOffset = offset;
            } else {
                currentNode = null;
            }
        }

        return currentOffset;
    },

    getTextFromXPath: function(e) {
        var textNodes = document.evaluate(e, document, null, XPathResult.STRING_TYPE, null);
        return textNodes.stringValue;
    },

    showNoteById: function(startXPath, startOffset, endXPath, endOffset) {// XPointer) {
        var startPoint = THCTagCore.XPathTranslator.tranlsateXPathToCurrent(startXPath, startOffset);
        var endPoint = THCTagCore.XPathTranslator.tranlsateXPathToCurrent(endXPath, endOffset);

        // get last item from splitted startPoint
        var startPointSplitted = startPoint[0].split("/");
        var startPointLastItem = startPointSplitted[startPointSplitted.length - 1].toLowerCase();
        var endPointSplitted = endPoint[0].split("/");
        var endPointLastItem = endPointSplitted[endPointSplitted.length - 1].toLowerCase();

        // if the last item of start node isn't a text node, get real node
        var lastNode = "";
        if ((startPointLastItem.substr(0,6) != "text()") && (startPointLastItem.substr(0,5) != "#text")) {
            // get last node
            lastNode = THCTagCore.XPathTranslator.getNodeAt(startPoint[0], startPoint[1] +1);
            lastNode = lastNode[0] + "[" + lastNode[1] + "]";

            startPoint[0] = [startPoint[0], lastNode].join("/");
            startPoint[1] = 0;
        }

        // if the last item of end node isn't a text node, get real node
        lastNode = "";
        if ((endPointLastItem.substr(0,6) != "text()") && (endPointLastItem.substr(0,5) != "#text")) {
            // get last node
            lastNode = THCTagCore.XPathTranslator.getNodeAt(endPoint[0], endPoint[1]);
            lastNode = lastNode[0] + "[" + lastNode[1] + "]";

            endPoint[0] = [endPoint[0], lastNode].join("/");
            endPoint[1] = 0;
        }


        // get start xpath and offset
        var startNode = document.evaluate(startPoint[0], document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0);
        var startNodeOffset = startPoint[1];

        // get end xpath and offset
        var endNode = document.evaluate(endPoint[0], document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0);
        var endNodeOffset = endPoint[1];

        // create highlight node
        var highlightNode = document.createElement("div");
        highlightNode.setAttribute("id", "THCHighlightNote");
        highlightNode.setAttribute("title", "Page fragment:");

        // create selection range
        var highlightRange = document.createRange();

        if (startNode.nodeType != Node.ELEMENT_NODE)
            highlightRange.setStart(startNode, startNodeOffset);
        else
            highlightRange.setStartBefore(startNode);

        if (endNode.nodeType != Node.ELEMENT_NODE)
            highlightRange.setEnd(endNode, endNodeOffset);
        else
            highlightRange.setEndAfter(endNode);

        // hide selectionLinkButton
        this.hideAllSelectionLinkButton();

        // clone current content
        var clonedRange = highlightRange.cloneContents();

        // show selectionLinkButton
        this.showAllSelectionLinkButton();

        // appne cloned content
        highlightNode.appendChild(clonedRange);

        // append content for dialog
        document.getElementsByTagName("body").item(0).appendChild(highlightNode);

        // show dialog
        jQuery("div#THCHighlightNote").dialog({
            bgiframe: true,
            modal: true,
            close: function() {
                var nodeToRemove = document.getElementById("THCHighlightNote");
                var parentNode = nodeToRemove.parentNode;
                parentNode.removeChild(nodeToRemove);
                THCTag.hide();
            }
        });

    },

    hideAllSelectionLinkButton: function() {
        jQuery(".THCLinkButton").hide();
    },

    showAllSelectionLinkButton: function() {
        jQuery(".THCLinkButton").show();
    }
};

THCTagCore.XPathTranslator = {
    // translate XPath to current document version
    // (add 1 for each previous THCTag)
    tranlsateXPathToCurrent: function(xpath, offset) {
        // if text() is not present, result is equal to xpath
        var result = [];  // xpath;
        var resultOffset = offset;

        // split xpath string
        var splittedXPathArray = this.splitXPath(xpath);

        // for each item of xpath
        for(var counter = 0; counter < splittedXPathArray.length; counter++) {
            // get current item
            var currentItem = splittedXPathArray[counter];

            // work on current item
            if(currentItem[0] != "") {
                // create current xpath
                var partialXPath = result.join("/");

                if(currentItem[0].substring(0,4) != "text") {
                    if(currentItem[1].toString() != "NaN")
                        currentItem[1] = this.getCurrentOffset(partialXPath, currentItem[0], currentItem[1]);
                } else {
                    var textNode = this.getCurrentTextOffset(partialXPath, currentItem[1], offset);

                    currentItem[0] = "text()";
                    currentItem[1] = textNode[0];
                    resultOffset = textNode[1];
                }
            }

            // add current item to result array
            if(currentItem[1].toString() != "NaN")
                result.push(currentItem[0] + "[" + currentItem[1] + "]");
            else
                result.push(currentItem[0]);
        }

        return [result.join("/"), resultOffset];

    },

    // translate XPath to original document version
    // (remove 1 for each previous THCTag)
    tranlsateXPathToOriginal: function(xpath, offset, shiftPolicy) {
        // if text() is not present, result is equal to xpath
        var result = [];
        var resultOffset = offset;

        // split xpath string
        var splittedXPathArray = this.splitXPath(xpath);

        // for each item of xpath
        for(var counter = 0; counter < splittedXPathArray.length; counter++) {
            // get current item
            var currentItem = splittedXPathArray[counter];

            // work on current item
            if(currentItem[0] != "") {
                // create current xpath
                var partialXPath = result.join("/");

                if(currentItem[0].substring(0,4) != "text") {
                    if(currentItem[1].toString() != "NaN") {
                        currentItem[1] = this.getOriginalOffset(partialXPath, currentItem[0], currentItem[1]);
                    }
                } else {
                    var textNode = this.getOriginalTextOffset(partialXPath, currentItem[1], offset);

                    currentItem[0] = "text()";
                    currentItem[1] = textNode[0];
                    resultOffset = textNode[1];
                }
            }

            // add current item to result array
            if(currentItem[1].toString() != "NaN")
                result.push(currentItem[0] + "[" + currentItem[1] + "]");
            else
                result.push(currentItem[0]);

            // check if currentItem is a THCNote
            if((currentItem[0] == "A") || ((currentItem[0] == "IMG"))) {
                var partialResult = result.join("/");
                partialResult = document.evaluate(partialResult, document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
                partialResult = partialResult.snapshotItem(0);

                if(THCTagCore.isTHCNote(partialResult)) {
                    // remove current item from result array
                    result.pop();
                    var newNode = null;

                    if(shiftPolicy == 'backward') {
                        newNode = this.shiftBackwardNode(partialResult);
                    }
                    if(shiftPolicy == 'forward') {
                        newNode = this.shiftForwardNode(partialResult);
                    }

                    if(newNode[0].substring(0,4) != "text") {
                        splittedXPathArray[counter][0] = newNode[0];
                        splittedXPathArray[counter][1] = newNode[1];
                    } else {
                        splittedXPathArray[counter][0] = newNode[0];
                        splittedXPathArray[counter][1] = this.getOffset(newNode[0]);
                        offset = newNode[1];
                    }

                    counter--;
                }
            }
        }

        return [result.join("/"), resultOffset];

    },

    shiftBackwardNode: function(e) {
        var result = [];
        // get privous node
        var backwardNode = e.previousSibling;

        if(backwardNode.nodeType == Node.ELEMENT_NODE) {
            result[0] = backwardNode.nodeName;
            result[1] = THCTagCore.XPath.getPreviousSiblingNodeWithSameName(backwardNode);
        }

        if(backwardNode.nodeType == Node.TEXT_NODE) {
            result[0] = "text()[" + THCTagCore.XPath.getPreviousSiblingNodeWithSameName(backwardNode) + "]";
            result[1] = backwardNode.nodeValue.length;
        }

        return result;
    },

    shiftForwardNode: function(e) {
        var result = [];
        // get next node
        var forwardNode = e.nextSibling;

        if(forwardNode.nodeType == Node.ELEMENT_NODE) {
            result[0] = forwardNode.nodeName;
            result[1] = THCTagCore.XPath.getPreviousSiblingNodeWithSameName(forwardNode);
        }

        if(forwardNode.nodeType == Node.TEXT_NODE) {
            result[0] = "text()[" + THCTagCore.XPath.getPreviousSiblingNodeWithSameName(forwardNode) + "]";
            result[1] = 0;
        }

        return result;
    },

    // split XPath in an array of elements
    splitXPath: function(xpath) {
        // split xpath string
        var result = xpath.split("/");
        // for each item in result
        for(var counter = 0; counter < result.length; counter++) {
            // get element name
            var element = this.getElement(result[counter]);
            // if element is not "", then get current offset
            var offset = Number.NaN;
            if(element != "")
                offset = this.getOffset(result[counter]);

            // if offset is NaN, element must be equal to original
            if(offset.toString() == "NaN")
                element = result[counter];

            result[counter] = [element, offset];
        }

        return result;
    },

    // get node form splitted xpath element
    // DIV[2] => DIV
    getElement: function(value) {
        if(value.indexOf("[") > 0)
            return value.substring(0, value.indexOf("["));
        else
            return value;

    },

    // get offset form splitted xpath element
    // DIV[2] => 2
    // DIV => 1
    // DIV[@id = 'abc'] => NaN
    getOffset: function(value) {
        if(value.indexOf("[") > 0) {
            var offset = value.substring(value.indexOf("[") + 1, value.indexOf("]"));

            return parseInt(offset);
        } else
            return 1;
    },

    // return the original offset for element node
    getOriginalOffset: function(xpath, name, offset) {

        var currentOffset = offset;
        var resultOffset = offset;

        var nodes = document.evaluate(xpath + "/node()", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        for(var counter = 0; counter < nodes.snapshotLength; counter++) {
            var node = nodes.snapshotItem(counter);

            if(node.nodeName == name) {
                currentOffset--;
            }

            if((name == "A") | (name == "IMG")) {
                if(THCTagCore.isTHCNote(node)) {
                    if(resultOffset > 1)
                        resultOffset--;
                }
            }

            if(currentOffset == 0)
                return resultOffset;
        }

        return null;
    },

    // return the original offset for element node
    getCurrentOffset: function(xpath, name, offset) {

        var currentOffset = offset;
        var resultOffset = offset;

        var nodes = document.evaluate(xpath + "/node()", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        for(var counter = 0; counter < nodes.snapshotLength; counter++) {
            var node = nodes.snapshotItem(counter);

            if(node.nodeName == name) {
                currentOffset--;
            }

            if((name == "A") | (name == "IMG")) {
                if(THCTagCore.isTHCNote(node)) {
                    currentOffset++;
                    resultOffset++;
                }
            }

            if(currentOffset == 0)
                return resultOffset;
        }

        return null;
    },

    // return the original offset for text node
    getOriginalTextOffset: function(xpath, offset, textOffset) {
        var currentOffset = offset;
        var resultOffset = offset;
        var resultTextOffset = 0;

        var nodes = document.evaluate(xpath + "/node()", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        for(var counter = 0; counter < nodes.snapshotLength; counter++) {
            var node = nodes.snapshotItem(counter);

            if(currentOffset > 0) {
                if(node.nodeName.toString() == "#text") {
                    currentOffset--;
                    resultTextOffset += node.nodeValue.length;

                } else {
                    if(!THCTagCore.isTHCNote(node))
                        resultTextOffset = 0;
                }

                if((node.nodeName.toString() == "A") | (node.nodeName.toString() == "IMG")) {
                    if(THCTagCore.isTHCNote(node)) {
                        resultOffset--;
                    }
                }
            }

            if(currentOffset == 0) {
                resultTextOffset += textOffset - node.nodeValue.length;
                currentOffset--;
            }
        }


        return [resultOffset, resultTextOffset];
    },

    // return the original offset for text node
    getCurrentTextOffset: function(xpath, offset, textOffset) {
        var currentOffset = offset;
        var resultOffset = 1;
        var resultTextOffset = textOffset;

        var nodes = document.evaluate(xpath + "/node()", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        var node = null;
        var endElementNode = 0;
        for(var counter = 0; counter < nodes.snapshotLength; counter++) {
            node = nodes.snapshotItem(counter);
            // get the first element after text node selected
            if(currentOffset > 1) {

                // we need to decrement currentOffset
                if(node.nodeType == Node.ELEMENT_NODE){
                    // Isn't it a THCNote tag?
                    if(!THCTagCore.isTHCNote(node)) {
                        // if current node have a previous text node
                        if((counter > 0) && (nodes.snapshotItem(counter - 1).nodeType == Node.TEXT_NODE))
                            currentOffset--;
                    }
                }

                if(node.nodeType == Node.TEXT_NODE){
                    resultOffset++;
                }

            }

            if(currentOffset == 1){
                endElementNode = counter;
                currentOffset--;
                counter = nodes.snapshotLength;
            }
        }

        node = null;
        var startElementNode = 0;
        // get the last element before actual text node selected
        for(var inverseCounter = endElementNode; inverseCounter > startElementNode; inverseCounter--) {
            node = nodes.snapshotItem(inverseCounter);

            if(node.nodeType == Node.ELEMENT_NODE){
                if(!THCTagCore.isTHCNote(node))
                    startElementNode = inverseCounter;
            }
        }

        // get real text node offset and text offset
        node = null;
        var result = [resultOffset, resultTextOffset];
        for(var forwardCounter = startElementNode; forwardCounter < nodes.snapshotLength; forwardCounter++) {
            node = nodes.snapshotItem(forwardCounter);

            if(node.nodeType == Node.TEXT_NODE){

                if(resultTextOffset > node.nodeValue.length) {
                    resultOffset++;
                    resultTextOffset -= node.nodeValue.length;
                } else {
                    result = [resultOffset, resultTextOffset];
                    forwardCounter = nodes.snapshotLength;
                }
            }

        }

        return result;

    },

    getNodeAt: function(xpath, offset) {
        var currentOffset = offset;
        var resultName = null;
        var resultOffset = 0;

        var nodes = document.evaluate(xpath + "/node()", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        var node = null;
        for(var counterName = 0; counterName < nodes.snapshotLength; counterName++) {
            node = nodes.snapshotItem(counterName);

            currentOffset--;

            if(currentOffset == 0)
                resultName = node.nodeName;
        }

        node = null;
        for(var counterOffset = 0; counterOffset < offset; counterOffset++) {
            node = nodes.snapshotItem(counterOffset);

            // increment resultOffset if current node name is equal to resultName
            if(node.nodeName == resultName) {
                resultOffset++;
            }

            // if current node is a THCNote, don't use it
            if((name == "A") || (name == "IMG")) {
                if(!THCTagCore.isTHCNote(node))
                    resultOffset--;
            }
        }

        // translate #text to text()
        if(resultName == "#text")
            resultName = "text()";

        return [resultName, resultOffset];
    }

};

THCTagUtil = {

    writeMessage: function(action, xpointer) {
        var xmlResult = '';

        switch (action) {
            case 'selection':
                xmlResult += '<thctag_message action=\'selection\'>\n';
                xmlResult += this.getNotifyMessage(xpointer);
                xmlResult += '</thctag_message>';
                break;
            case 'focus':
                xmlResult += '<thctag_message action=\'focus\'>\n';
                xmlResult += this.getFocusMessage(xpointer);
                xmlResult += '</thctag_message>';
                break;
            case 'lost_focus':
                xmlResult += '<thctag_message action=\'focus\'>\n';
                xmlResult += this.getLostFocusMessage();
                xmlResult += '</thctag_message>';
                break;
            case 'undefined':
                return;
                break;
            default:
                xmlResult += '<thctag_message>\n';
                xmlResult += '</thctag_message>';
                break;
        }

        window.status = xmlResult;
    },

    getNotifyMessage: function(xpointer) {

        var xmlResult = '';

        xmlResult += '<browser_selection>\n';
        xmlResult += '<xpointer>' + xpointer + '</xpointer>\n';
        xmlResult += '<page_url>' + window.location.href + '</page_url>\n';
        xmlResult += '<content>' + THCTagCore.getSelectedRange() + '</content>';
        xmlResult += '</browser_selection>\n';

        return xmlResult;
    },

    getFocusMessage: function(xpointer) {
        var xmlResult = '';

        xmlResult += '<browser_selection>\n';
        xmlResult += '<xpointer>' + xpointer + '</xpointer>\n';
        xmlResult += '<page_url>' + window.location.href + '</page_url>\n';
        xmlResult += '</browser_selection>\n';

        return xmlResult;
    },

    getLostFocusMessage: function() {
        var xmlResult = '';

        xmlResult += '<browser_selection>\n';
        xmlResult += '<page_url>' + window.location.href + '</page_url>\n';
        xmlResult += '</browser_selection>\n';

        return xmlResult;
    }
};

