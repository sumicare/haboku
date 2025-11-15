/**
   Copyright 2025 Sumicare

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import type { UserConfig } from '@commitlint/types'

export default {
  extends: ['@commitlint/config-conventional'],
  helpUrl: 'https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional',
  ignores: [
    (msg: string) => msg.startsWith('wip: ') || msg.startsWith('wip('),
    (msg: string) => msg.startsWith('chore: ') || msg.startsWith('chore('),
    () => (process.env.COMMITLINT_DISABLE || 'false').toLowerCase() === 'true'
  ],
  parserPreset: {
    parserOpts: {
      headerCorrespondence: ['type', 'scope', 'ticket', 'subject'],
      headerPattern: /^(\w*)(\(\w+\))?:\s(?:(\[#\d+\])\s)?(.*)$/,
      issuePrefixes: ['#']
    }
  },
  rules: {
    'body-leading-blank': [1, 'always'],
    'body-max-line-length': [2, 'always', 100],
    'footer-leading-blank': [1, 'always'],
    'footer-max-line-length': [2, 'always', 100],
    'header-max-length': [2, 'always', 100],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never'],
    'type-enum': [
      2,
      'always',
      [
        'build', // Changes that affect the build system or external dependencies
        'chore', // Other changes that don't modify src or test files
        'ci', // Changes to our CI configuration files and scripts
        'docs', // Documentation only changes
        'feat', // A new feature
        'fix', // A bug fix
        'perf', // A code change that improves performance
        'refactor', // A code change that neither fixes a bug nor adds a feature
        'revert', // Reverts a previous commit
        'style', // Formatting changes that do not affect the meaning of the code
        'test', // Adding missing tests or correcting existing tests
        'wip' // Work in progress (skip commitlint, added to these rules for convenience)
      ]
    ]
  }
} satisfies UserConfig
