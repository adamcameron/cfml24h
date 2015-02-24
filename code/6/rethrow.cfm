<cfscript>
try {
    result = 1 / 0;
} catch (any e){
    writeOutput("type: #e.type#; message: #e.message#");
    rethrow;
}
</cfscript>