import { cli, devOps } from "@azure/avocado";
import * as logger from "./logger";
import "./stringExtenssions";
import { PullRequestProperties } from '@azure/avocado/dist/dev-ops';
import gitP, { SimpleGit } from 'simple-git/promise';

let pullRequestDetails: PullRequestProperties | undefined;
const workingDir:string = process.cwd();
const git: SimpleGit = gitP(workingDir);

export async function GetPRDetails() {
  if (typeof pullRequestDetails == "undefined"){
    console.log("Getting PR details");
    const config = cli.defaultConfig();
    pullRequestDetails = await devOps.createPullRequestProperties(config);
  }
  return pullRequestDetails;
}

export async function GetDiffFiles(fileKinds: string[], fileTypeSuffixes?: string[], filePathFolderPreffixes?: string[]) {
  const pr = await GetPRDetails();

  if (typeof pr === "undefined") {
    console.log("Azure DevOps CI for a Pull Request wasn't found. If issue persists - please open an issue");
    return;
  }
 
  let changedFiles = await pr.diff();
  console.log(`${changedFiles.length} files changed in current PR`);
  let options = [pr.targetBranch, pr.sourceBranch, "Workbooks/WorkbooksMetadata.json"];
  let diffSummary = await git.diff(options);
  console.log(diffSummary)

  const filterChangedFiles = changedFiles
    .filter(change => fileKinds.includes(change.kind))
    .map(change => change.path)
    .filter(filePath => typeof fileTypeSuffixes === "undefined" || filePath.endsWithAny(fileTypeSuffixes))
    .filter(filePath => typeof filePathFolderPreffixes === "undefined" || filePath.startsWithAny(filePathFolderPreffixes))
    .filter(filePath => filePath.indexOf(".script/tests") === -1);

  if (filterChangedFiles.length === 0) {
    logger.logWarning(`No changed files in current PR after files filter. File type filter: ${fileTypeSuffixes ? fileTypeSuffixes.toString() : null}, 
        File path filter: ${filePathFolderPreffixes ? filePathFolderPreffixes.toString() : null}`);
    return;
  }

  let fileKindsLogValue = fileKinds.join(",");
  let fileTypeSuffixesLogValue = typeof fileTypeSuffixes === "undefined" ? null : fileTypeSuffixes.join(",");
  let filePathFolderPreffixesLogValue = typeof filePathFolderPreffixes === "undefined" ? null : filePathFolderPreffixes.join(",");
  console.log(`${filterChangedFiles.length} files changed in current PR after filter. File Type Filter: ${fileTypeSuffixesLogValue}, File path Filter: ${filePathFolderPreffixesLogValue}, File Kind Filter: ${fileKindsLogValue}`);

  return filterChangedFiles;
}
