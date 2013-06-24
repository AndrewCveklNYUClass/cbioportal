<%@ page import="org.mskcc.cbio.portal.model.GeneWithScore" %>
<%@ page import="org.mskcc.cbio.portal.servlet.QueryBuilder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.mskcc.cbio.portal.servlet.GeneratePlots" %>
<%@ page import="org.mskcc.cbio.cgds.model.GeneticProfile" %>
<%@ page import="org.mskcc.cbio.cgds.model.GeneticAlterationType" %>

<%
    String cancer_study_id = (String)request.getParameter("cancer_study_id");
    String case_set_id = (String)request.getParameter("case_set_id");
    String genetic_profile_id = (String)request.getParameter("genetic_profile_id");

    //Interprete Onco Query Genelist for plots view
    String[] plotsGeneList = new String[geneWithScoreList.size()];
    for (int i = 0; i < geneWithScoreList.size(); i++)
    {
        GeneWithScore tmpSingleGene = geneWithScoreList.get(i);
        String singleGene = tmpSingleGene.getGene();
        plotsGeneList[i] = singleGene;
    }
    String[] gene_list = plotsGeneList;

    //tmp gene list string
    String tmpGeneStr="";
    for(int i=0;i<gene_list.length;i++) {
        tmpGeneStr+=gene_list[i] + " ";
    }
    tmpGeneStr = tmpGeneStr.substring(0, tmpGeneStr.length() - 1);
%>

<script type="text/javascript" src="js/plots_tab_model.js"></script>
<script type="text/javascript" src="js/plots_tab.js"></script>


<!-- Global Variables -->
<script>
    var cancer_study_id = "<%out.print(cancer_study_id);%>",
            case_set_id = "<%out.print(case_set_id);%>";
    case_ids_key = "";

    if (case_set_id === "-1") {
        case_ids_key = "<%out.print(caseIdsKey);%>";
    }

    var genetic_profile_id = "<%out.print(genetic_profile_id);%>";
    var gene_list_str = "<%out.print(tmpGeneStr);%>";
</script>

<style>
    .plots-tabs-ref{
        font-size:11px !important;
    }
</style>

<div class="section" id="plots">
    <div id="plots-tabs" class="plots-tabs">

        <!--Generating sub tabs-->
        <ul>
            <li><a href="#plots_one_gene" title="Single Gene Query" class="plots-tabs-ref"><span>One Gene</span></a></li>
            <li><a href="#plots_two_genes" title="Cross Gene Query" class="plots-tabs-ref"><span>Two Genes</span></a></li>
            <li><a href="#plots_custom" title="Advanced Multi-gene view" class="plots-tabs-ref"><span>Custom</span></a></li>
        </ul>

        <div id="plots_one_gene">
            <table>
            <tr>
                <!-- Side Menu Column -->
                <td>
                    <table>
                        <tr>
                            <td style="border:2px solid #BDBDBD;padding:10px;height:300px;">
                                <h4 style="padding-top:10px;">Plot Parameters</h4>
                                <br>
                                <b>Gene</b><br>
                                <%
                                    if (gene_list.length == 1) {
                                        out.print("&nbsp;" + gene_list[0]);
                                    }
                                %>
                                <%
                                    if (gene_list.length == 1){
                                        out.println("<select id='genes' style='display:none;' onchange='PlotsView.init()'>");
                                        out.println("<option value='" + gene_list[0].toUpperCase() +
                                                "'>" + gene_list[0].toUpperCase() + "</option>");
                                    } else {
                                        out.println("<select id='genes' onchange='PlotsView.init()'>");
                                        for (int i = 0; i < gene_list.length; i++){
                                            out.println("<option value='" + gene_list[i].toUpperCase() +
                                                    "'>" + gene_list[i].toUpperCase() + "</option>");
                                        }
                                    }
                                %>
                                </select>
                                <br><br>
                                <b>Plot Type</b><br>
                                <select id='plots_type' onchange="PlotsMenu.update();"></select>
                                <br><br>
                                <b>Data Type</b><br>
                                <!-- Hidden -->
                                <div id='mutation_dropdown' style='padding:5px;display:none'>
                                    <select id='data_type_mutation'></select>
                                </div>
                                <div id='mrna_dropdown' style='padding:5px;'>
                                    - mRNA - <br>
                                    <select id='data_type_mrna' onchange="PlotsView.init()"></select>
                                </div>
                                <div id='copy_no_dropdown'style='padding:5px;'>
                                    - Copy Number - <br>
                                    <select id='data_type_copy_no' onchange="PlotsView.init()"></select>
                                </div>
                                <div id='dna_methylation_dropdown'style='padding:5px;'>
                                    - DNA Methylation - <br>
                                    <select id='data_type_dna_methylation' onchange="PlotsView.init()"></select>
                                </div>
                                <div id='rppa_dropdown'style='padding:5px;'>
                                    - RPPA Protein Level - <br>
                                    <select id='data_type_rppa' onchange="PlotsView.init()"></select>
                                </div>
                            </td>
                        </tr>
                        <!-- Place Holder at the buttom for the side menu-->
                        <tr style="height:320px;"></tr>
                    </table>
                </td>
                <!-- Plots View-->
                <td>
                    <div id='loading-image'>
                        <img style='padding:200px;' src='images/ajax-loader.gif'>
                    </div>
                    <b><div id='view_title' style="display:inline-block;padding-left:100px;"></div></b>
                    <div id="plots_box"></div>
                </td>
            </tr>
        </table>
        </div>
        <div id="plots_two_genes">
            Something two genes
        </div>
        <div id="plots_custom">
            Custom gene view
        </div>

    </div>
</div>

<script>
    window.onload = PlotsMenu.init();
    window.onload = PlotsMenu.update();

    // Takes whatever is in the element #plots_box
    // and returns XML serialized *string*
    function loadSVGforPDF() {
        var mySVG = document.getElementById("plots_box");
        var svgDoc = mySVG.getElementsByTagName("svg");
        var xmlSerializer = new XMLSerializer();
        var xmlString = xmlSerializer.serializeToString(svgDoc[0]);
        xmlString = xmlString.replace(/<\/line><text y="9" x="0" dy=".71em"/g, "</line><text y=\"19\" x=\"0\" dy=\".71em\"");
        xmlString = xmlString.replace(/<\/line><text x="-9" y="0" dy=".32em"/g, "</line><text x=\"-9\" y=\"3\" dy=\".32em\"");
        return xmlString;
    }
    function loadSVGforSVG() {
        var mySVG = document.getElementById("plots_box");
        var svgDoc = mySVG.getElementsByTagName("svg");
        var xmlSerializer = new XMLSerializer();
        var xmlString = xmlSerializer.serializeToString(svgDoc[0]);
        return xmlString;
    }

    //Patch for the sub tab css style and qtip bug. (Overwrite)
    $(".plots-tabs-ref").tipTip(
            {defaultPosition: "top", delay:"100", edgeOffset: 10, maxWidth: 200});

</script>




