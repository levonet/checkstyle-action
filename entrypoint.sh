#!/bin/sh

echo "Running check"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ -n "${INPUT_PROPERTIES_FILE}" ]; then
  OPT_PROPERTIES_FILE="-p ${INPUT_PROPERTIES_FILE}"
fi

env | sort

echo java -jar /checkstyle.jar \
    -c "${INPUT_CHECKSTYLE_CONFIG}" \
    ${OPT_PROPERTIES_FILE} \
    -f xml \
    "${INPUT_FILES}"

exec java -jar /checkstyle.jar \
    -c "${INPUT_CHECKSTYLE_CONFIG}" \
    ${OPT_PROPERTIES_FILE} \
    -f xml \
    ${INPUT_FILES} \
    | reviewdog -f=checkstyle \
        -name="${INPUT_TOOL_NAME}" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -filter-mode="${INPUT_FILTER_MODE:-added}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
        -level="${INPUT_LEVEL}"
