Ext.ns('Openwis.RequestSubscription.SubSelectionParameters.SingleSelection');

Openwis.RequestSubscription.SubSelectionParameters.SingleSelection.Radio = Ext.extend(Ext.form.RadioGroup, {
	
	initComponent: function() {
		Ext.apply(this, 
		{
		    allowBlank: false,
			columns: 2,
			items: this.getItems(),
			listeners : {
				change: function() {
					this.fireEvent("valueChanged");
				}
			}
			
		});
		Openwis.RequestSubscription.SubSelectionParameters.SingleSelection.Radio.superclass.initComponent.apply(this, arguments);
		
	    this.addEvents("valueChanged");
	},
	
	//----------------------------------------------------------------- Initialization of the panels.
	
	getItems: function() {
	    //Build the list of values (filter if previous specified, false otherwise).
	    var matcher = new Openwis.RequestSubscription.SubSelectionParameters.Helper.Matcher();    
    
        var matchingValues = [];
        if(this.config.previous) {
            Ext.each(this.config.parameter.values, 
                function(item, index, allItems) {
                    if(matcher.matches(item.availableFor, this.config.previous.type, this.config.previous.selection)) {
                        matchingValues.push(item);
                    }
                },
                this
            );
        } else {
            matchingValues = this.config.parameter.values;
        }
	    
	    //Re-initiates to the old selection if available.
	    var overridenSelection = {};
	    if(this.config.editValue || this.config.currentElementSelection) {
	         var elementsToKeepSelected = [];
    	     if(this.config.editValue) {
    	         elementsToKeepSelected.push(this.config.editValue[0]);
    	     } else if(this.config.currentElementSelection) {
                Ext.each(matchingValues, 
                    function(item, index, allItems) {
                        if(this.config.currentElementSelection.indexOf(item.code) != -1) {
                            elementsToKeepSelected.push(item.code);
                        }
                    },
                    this
                );
             }
        	    
            //Set as selected/unselected if elements were selected, stay by default otherwise.
            if(!Ext.isEmpty(elementsToKeepSelected)) {
                Ext.each(matchingValues, 
                    function(item, index, allItems) {
                        overridenSelection[item.code] = (elementsToKeepSelected.indexOf(item.code) != -1);
                    },
                    this
                );
            }
    	}
	    
	    //Build the radio components.
	    var items = [];
	    Ext.each(matchingValues, 
	        function(item, index, allItems) {
	            var selected = overridenSelection[item.code] != null ? overridenSelection[item.code] : item.selected;
	            items.push({
	                boxLabel: item.value, 
	                name: this.config.parameter.code, 
	                id: item.code, 
	                checked: selected, 
	                height: 25, 
	                width: 200
	            });    
	        },
	        this
	    );
	    return items;
	},
	
	//----------------------------------------------------------------- Generic methods used by the wizard.

	buildValue: function() {
		var out = null;
        this.eachItem(function(item){
            if(item.checked){
                out = item.id;
                return false;
            }
        });
        return out;
	}
});