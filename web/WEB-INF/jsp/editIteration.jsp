<%@ include file="./inc/_taglibs.jsp"%>
<%@ include file="./inc/_header.jsp"%>

<c:choose>
	<c:when test="${iteration.id == 0}">
		<aef:bct projectId="${projectId}" />
	</c:when>
	<c:otherwise>
		<aef:bct iterationId="${iterationId}" />
	</c:otherwise>
</c:choose>

<c:set var="divId" value="1336" scope="page" />
<aef:menu navi="backlog" pageHierarchy="${pageHierarchy}" />
<aef:productList />

<ww:actionerror />
<ww:actionmessage />

<h2><c:out value="${iteration.name}" /></h2>
<table>
	<table>
		<tbody>
			<tr>
				<td>
				<div class="subItems" style="margin-top: 0">
				<div class="subItemHeader"><script type="text/javascript">
                function expandDescription() {
                    document.getElementById('descriptionDiv').style.maxHeight = "1000em";
                    document.getElementById('descriptionDiv').style.overflow = "visible";
                }
                function collapseDescription() {
                    document.getElementById('descriptionDiv').style.maxHeight = "12em";
                    document.getElementById('descriptionDiv').style.overflow = "hidden";
                }
                function editIteration() {
                	toggleDiv('editIterationForm'); toggleDiv('descriptionDiv'); showWysiwyg('iterationDescription'); return false;
                }
                </script>


				<table cellspacing="0" cellpadding="0">
					<tr>
						<td class="header">Details <a href=""
							onclick="return editIteration();">Edit &raquo;</a></td>
						<td class="icons"><a href=""
							onclick="expandDescription(); return false;"> <img
							src="static/img/plus.png" width="18" height="18" alt="Expand"
							title="Expand" /> </a> <a href=""
							onclick="collapseDescription(); return false;"> <img
							src="static/img/minus.png" width="18" height="18" alt="Collapse"
							title="Collapse" /> </a></td>
					</tr>
				</table>
				</div>
				<div class="subItemContent">
				<div id="descriptionDiv" class="descriptionDiv"
					style="display: block;">
				<table class="infoTable" cellpadding="0" cellspacing="0">
					<tr>
						<th class="info1">Timeframe</th>
						<td class="info3" ondblclick="return editIteration();"><c:out
							value="${iteration.startDate.date}.${iteration.startDate.month + 1}.${iteration.startDate.year + 1900}" />
						- <c:out
							value="${iteration.endDate.date}.${iteration.endDate.month + 1}.${iteration.endDate.year + 1900}" /></td>
						<td class="info4" rowspan="3">
						<div class="smallBurndown"><a href="#bigChart"><img
							src="drawSmallChart.action?iterationId=${iteration.id}" /></a></div>

						<table>
							<tr>
								<th>Velocity</th>
								<td><c:out value="${iterationMetrics.dailyVelocity}" /> /
								day</td>
							</tr>
							<c:if test="${iterationMetrics.backlogOngoing}">
								<tr>
									<th>Schedule variance</th>
									<td><c:choose>
										<c:when test="${iterationMetrics.scheduleVariance != null}">
											<c:choose>
												<c:when test="${iterationMetrics.scheduleVariance > 0}">
													<span class="red">+ 
												</c:when>
												<c:otherwise>
													<span>
												</c:otherwise>
											</c:choose>
											<c:out value="${iterationMetrics.scheduleVariance}" /> days
                                            </c:when>
										<c:otherwise>
                                                unknown
                                            </c:otherwise>
									</c:choose></td>
								</tr>
								<tr>
									<th>Scoping needed</th>
									<td><c:choose>
										<c:when test="${iterationMetrics.scopingNeeded != null}">
											<c:out value="${iterationMetrics.scopingNeeded}" />
										</c:when>
										<c:otherwise>
                                                unknown
                                            </c:otherwise>
									</c:choose></td>
								</tr>
							</c:if>
							<tr>
								<th>Completed</th>
								<td><c:out value="${iterationMetrics.percentDone}" />% (<c:out
									value="${iterationMetrics.completedItems}" /> / <c:out
									value="${iterationMetrics.totalItems}" />)</td>
							</tr>
						</table>

						</td>
					</tr>

					<tr>
						<td colspan="2" class="description">${iteration.description}</td>
						<td></td>
					</tr>

				</table>
				</div>
				<div id="editIterationForm" style="display: none;"><ww:form
					method="post" action="storeIteration">
					<ww:hidden name="iterationId" value="${iteration.id}" />
					<ww:date name="%{iteration.getTimeOfDayDate(6)}" id="start"
						format="%{getText('webwork.shortDateTime.format')}" />
					<ww:date name="%{iteration.getTimeOfDayDate(18)}" id="end"
						format="%{getText('webwork.shortDateTime.format')}" />
					<c:if test="${iteration.id > 0}">
						<ww:date name="%{iteration.startDate}" id="start"
							format="%{getText('webwork.shortDateTime.format')}" />
						<ww:date name="%{iteration.endDate}" id="end"
							format="%{getText('webwork.shortDateTime.format')}" />
					</c:if>

					<table class="formTable">
						<tr>
							<td>Name</td>
							<td>*</td>
							<td colspan="2"><ww:textfield size="60"
								name="iteration.name" /></td>
						</tr>
						<tr>
							<td>Description</td>
							<td></td>
							<td colspan="2"><ww:textarea cols="70" rows="10"
								id="iterationDescription" name="iteration.description"
								value="${aef:nl2br(iteration.description)}" /></td>
						</tr>
						<tr>
							<td>Project</td>
							<td>*</td>
							<td colspan="2"><select name="projectId"
								onchange="disableIfEmpty(this.value, ['saveButton']);">
								<option class="inactive" value="">(select project)</option>
								<c:forEach items="${productList}" var="product">
									<option value="" class="inactive productOption">${aef:out(product.name)}</option>
									<c:forEach items="${product.projects}" var="project">
										<c:choose>
											<c:when test="${project.id == currentProjectId}">
												<option selected="selected" value="${project.id}"
													class="projectOption" title="${project.name}">${aef:out(project.name)}</option>
											</c:when>
											<c:otherwise>
												<option value="${project.id}" title="${project.name}"
													class="projectOption">${aef:out(project.name)}</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</c:forEach>
							</select></td>
						</tr>
						<tr>
							<td>Start date</td>
							<td>*</td>
							<td colspan="2"><%--<ww:datepicker value="%{#start}" size="15"
										showstime="true"
										format="%{getText('webwork.datepicker.format')}"
										name="startDate" />--%> <aef:datepicker id="start_date"
								name="startDate"
								format="%{getText('webwork.shortDateTime.format')}"
								value="%{#start}" /></td>
						</tr>
						<tr>
							<td>End date</td>
							<td>*</td>
							<td colspan="2"><%--<ww:datepicker value="%{#end}" size="15"
										showstime="true"
										format="%{getText('webwork.datepicker.format')}"
										name="endDate" />--%> <aef:datepicker id="end_date"
								name="endDate"
								format="%{getText('webwork.shortDateTime.format')}"
								value="%{#end}" /></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<c:choose>
								<c:when test="${iterationId == 0}">
									<td><ww:submit value="Create" /></td>
								</c:when>
								<c:otherwise>
									<td><ww:submit value="Save" id="saveButton" /></td>
									<td class="deleteButton"><ww:submit
										onclick="return confirmDelete()" action="deleteIteration"
										value="Delete" /></td>
								</c:otherwise>
							</c:choose>
						</tr>
					</table>
				</ww:form></div>
				</div>
				</div>
				</td>
			</tr>
		</tbody>
	</table>


	<script type="text/javascript">
$(document).ready( function() {
    $('.moveUp').click(function() {
        var me = $(this);
        $.get(me.attr('href'), null, function() {me.moveup();});
        return false;
        });
    $('.moveDown').click(function() {
        var me = $(this);
        $.get(me.attr('href'), null, function() {me.movedown();});
        return false;
        });
    $('.moveTop').click(function() {
        var me = $(this);
        $.get(me.attr('href'), null, function() {me.movetop();});
        return false;
        });
    $('.moveBottom').click(function() {
        var me = $(this);
        $.get(me.attr('href'), null, function() {me.movebottom();});
        return false;
        });
});
</script>


	<table>
		<tr>
			<td><c:if test="${iterationId != 0}">
				<div class="subItems">
				<div class="subItemHeader">
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td class="header">Iteration goals <ww:url
							id="createIterationGoalLink" action="ajaxCreateIterationGoal"
							includeParams="none">
							<ww:param name="iterationId" value="${iteration.id}" />
						</ww:url> <ww:a cssClass="openCreateDialog openIterationGoalDialog"
							href="%{createIterationGoalLink}&contextViewName=editIteration&contextObjectId=${iteration.id}">Create new &raquo;</ww:a>
						</td>
					</tr>
				</table>
				</div>
				<c:if test="${!empty iteration.iterationGoals}">
					<aef:hourReporting id="hourReport"></aef:hourReporting>
					<c:if test="${hourReport}">
						<aef:backlogHourEntrySums id="iterationGoalEffortSpent"
							groupBy="IterationGoal" target="${iteration}" />
					</c:if>
					<div class="subItemContent">
					<p><display:table class="listTable"
						name="iteration.iterationGoals" id="row"
						requestURI="editIteration.action">

						<display:column sortable="true" title="Name" sortProperty="name"
							class="iterationGoalNameColumn">
							<ww:url id="editLink" action="editIterationGoal"
								includeParams="none">
								<ww:param name="iterationGoalId" value="${row.id}" />
							</ww:url>
							<ww:a
								href="%{editLink}&contextViewName=editIteration&contextObjectId=${iteration.id}">
						${aef:html(row.name)}
					</ww:a>
						</display:column>

						<display:column sortable="true" sortProperty="description"
							title="Description">
					${aef:html(row.description)}
				</display:column>
						<display:column sortable="false" title="# of backlog items">
				  ${aef:html(fn:length(row.backlogItems))}
				</display:column>

						<display:column sortable="false" title="Effort left sum">
							<c:out value="${iterationGoalEffLeftSums[row.id]}" />
						</display:column>

						<display:column sortable="false" title="Original estimate sum">
							<c:out value="${iterationGoalOrigEstSums[row.id]}" />
						</display:column>

						<c:if test="${hourReport}">
							<display:column sortable="false" title="Effort Spent">
								<c:choose>
									<c:when test="${iterationGoalEffortSpent[row.id] != null}">
										<c:out value="${iterationGoalEffortSpent[row.id]}" />
									</c:when>
									<c:otherwise>&mdash;</c:otherwise>
								</c:choose>
							</display:column>
						</c:if>

						<display:column sortable="false" title="Actions"
							class="actionColumn">
							<ww:url id="moveTopLink" action="prioritizeIterationGoal"
								includeParams="none">
								<ww:param name="iterationGoalId" value="${row.id}" />
								<ww:param name="iterationId" value="${iterationId}" />
							</ww:url>
							<ww:a cssClass="moveTop" href="%{moveTopLink}&amp;moveTo=top">
								<img src="static/img/arrow_top.png" alt="Send to top"
									title="Send to top" />
							</ww:a>

							<ww:url id="moveUpLink" action="prioritizeIterationGoal"
								includeParams="none">
								<ww:param name="iterationGoalId" value="${row.id}" />
								<ww:param name="iterationId" value="${iterationId}" />
							</ww:url>
							<ww:a cssClass="moveUp" href="%{moveUpLink}&amp;moveTo=up">
								<img src="static/img/arrow_up.png" alt="Move up" title="Move up" />
							</ww:a>
							<ww:url id="moveDownLink" action="prioritizeIterationGoal"
								includeParams="none">
								<ww:param name="iterationGoalId" value="${row.id}" />
								<ww:param name="iterationId" value="${iterationId}" />
							</ww:url>
							<ww:a cssClass="moveDown" href="%{moveDownLink}&amp;moveTo=down">
								<img src="static/img/arrow_down.png" alt="Move down"
									title="Move down" />
							</ww:a>

							<ww:url id="moveBottomLink" action="prioritizeIterationGoal"
								includeParams="none">
								<ww:param name="iterationGoalId" value="${row.id}" />
								<ww:param name="iterationId" value="${iterationId}" />
							</ww:url>
							<ww:a cssClass="moveBottom"
								href="%{moveBottomLink}&amp;moveTo=bottom">
								<img src="static/img/arrow_bottom.png" alt="Send to bottom"
									title="Send to bottom" />
							</ww:a>
							<ww:url id="deleteLink" action="deleteIterationGoal"
								includeParams="none">
								<ww:param name="iterationGoalId" value="${row.id}" />
								<ww:param name="iterationId" value="${iteration.id}" />
							</ww:url>
							<ww:a href="%{deleteLink}" onclick="return confirmDelete()">
								<img src="static/img/delete_18.png" alt="Delete" title="Delete" />
							</ww:a>
						</display:column>

					</display:table></p>
					</div>
				</c:if>
                </div>
                <div class="subItems">
				<div id="subItemHeader">
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td class="header">Backlog items <ww:url
							id="createBacklogItemLink" action="ajaxCreateBacklogItem"
							includeParams="none">
							<ww:param name="backlogId" value="${iteration.id}" />
						</ww:url> <ww:a cssClass="openCreateDialog openBacklogItemDialog"
							href="%{createBacklogItemLink}&contextViewName=editIteration&contextObjectId=${iteration.id}">Create new &raquo;</ww:a>
						</td>
					</tr>
				</table>
				</div>

				<c:if test="${!empty iteration.backlogItems}">
					<div class="subItemContent">
					<p><%@ include file="./inc/_backlogList.jsp"%>
					</p>
					</div>
				</c:if></div>
				<p><img src="drawChart.action?iterationId=${iteration.id}"
					id="bigChart" width="780" height="600" /></p>
			</c:if></td>
		</tr>
	</table>

	<%@ include file="./inc/_footer.jsp"%>