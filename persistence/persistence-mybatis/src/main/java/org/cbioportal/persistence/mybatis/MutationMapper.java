package org.cbioportal.persistence.mybatis;

import org.cbioportal.model.AnnotationFilter;
import org.cbioportal.model.Mutation;
import org.cbioportal.model.MutationCountByPosition;
import org.cbioportal.model.MutationCountByGene;
import org.cbioportal.model.meta.MutationMeta;

import java.util.List;

public interface MutationMapper {

    List<Mutation> getMutationsBySampleListId(String molecularProfileId, String sampleListId, List<Integer> entrezGeneIds,
                                              Boolean snpOnly, String projection, Integer limit, Integer offset,
                                              String sortBy, String direction);

    MutationMeta getMetaMutationsBySampleListId(String molecularProfileId, String sampleListId,
                                                List<Integer> entrezGeneIds, Boolean snpOnly);

    List<Mutation> getMutationsInMultipleMolecularProfiles(List<String> molecularProfileIds, List<String> sampleIds,
                                                           List<Integer> entrezGeneIds, Boolean snpOnly,
                                                           String projection, Integer limit, Integer offset,
                                                           String sortBy, String direction);

    List<Mutation> getMutationsInMultipleMolecularProfilesByAnnotation(List<String> molecularProfileIds, List<String> sampleIds,
                                                           List<Integer> entrezGeneIds, Boolean snpOnly,
                                                           String projection, Integer limit, Integer offset,
                                                           String sortBy, String direction, List<AnnotationFilter> filters);

    MutationMeta getMetaMutationsInMultipleMolecularProfiles(List<String> molecularProfileIds, List<String> sampleIds,
                                                             List<Integer> entrezGeneIds, Boolean snpOnly);

    List<Mutation> getMutationsBySampleIds(String molecularProfileId, List<String> sampleIds,
                                           List<Integer> entrezGeneIds, Boolean snpOnly, String projection,
                                           Integer limit, Integer offset, String sortBy, String direction);

    MutationMeta getMetaMutationsBySampleIds(String molecularProfileId, List<String> sampleIds,
                                             List<Integer> entrezGeneIds, Boolean snpOnly);

    List<MutationCountByGene> getSampleCountByEntrezGeneIdsAndSampleIds(String molecularProfileId,
                                                                        List<String> sampleIds,
                                                                        List<Integer> entrezGeneIds,
                                                                        Boolean snpOnly);

    List<MutationCountByGene> getSampleCountInMultipleMolecularProfiles(List<String> molecularProfileIds,
                                                                        List<String> sampleIds,
                                                                        List<Integer> entrezGeneIds,
                                                                        Boolean snpOnly);

    List<MutationCountByGene> getSampleCountInMultipleMolecularProfilesByAnnotation(List<String> molecularProfileIds,
                                                                        List<String> sampleIds,
                                                                        List<Integer> entrezGeneIds,
                                                                        Boolean snpOnly,
                                                                        List<AnnotationFilter> filters);

    List<MutationCountByGene> getPatientCountByEntrezGeneIdsAndSampleIds(String molecularProfileId,
                                                                         List<String> patientIds,
                                                                         List<Integer> entrezGeneIds,
                                                                         Boolean snpOnly);

    MutationCountByPosition getMutationCountByPosition(Integer entrezGeneId, Integer proteinPosStart,
                                                       Integer proteinPosEnd);
}
