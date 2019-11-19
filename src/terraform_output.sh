#!/bin/bash

function terraformOutput {
  # Gather the output of `terraform output`.
  if [ "${INPUT_USE_TERRAGRUNT}" == "true" ]; then
    echo "output: info: gathering all the outputs for the Terraform configuration in ${tfWorkingDir}"
    outputOutput=$(terragrunt output -json ${*} 2>&1)
    outputExitCode=${?}
  else
    echo "output: info: gathering all the outputs for the Terraform configuration in ${tfWorkingDir}"
    outputOutput=$(terraform output -json ${*} 2>&1)
    outputExitCode=${?}
  fi

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${outputExitCode} -eq 0 ]; then
    echo "output: info: successfully gathered all the outputs for the Terraform configuration in ${tfWorkingDir}"
    echo "${outputOutput}"
    echo
    echo ::set-output name=tf_actions_output::${outputOutput}
    exit ${outputExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "output: error: failed to gather all the outputs for the Terraform configuration in ${tfWorkingDir}"
  echo "${outputOutput}"
  echo
  exit ${outputExitCode}
}
