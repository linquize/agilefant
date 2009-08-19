package fi.hut.soberit.agilefant.business;

import java.util.Collection;

import fi.hut.soberit.agilefant.exception.ObjectNotFoundException;
import fi.hut.soberit.agilefant.model.Project;
import fi.hut.soberit.agilefant.model.User;
import fi.hut.soberit.agilefant.transfer.ProjectMetrics;

public interface ProjectBusiness extends GenericBusiness<Project> {


    /**
     * Get users assigned to the project.
     */
    public Collection<User> getAssignedUsers(Project project);
    
    public Project store(int projectId, Integer productId, Project project) throws ObjectNotFoundException,
            IllegalArgumentException;

    public ProjectMetrics getProjectMetrics(Project project);
}
