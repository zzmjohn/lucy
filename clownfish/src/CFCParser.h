/* Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef H_CFCPARSER
#define H_CFCPARSER

#ifdef __cplusplus
extern "C" {
#endif

typedef struct CFCParser CFCParser;
struct CFCBase;
struct CFCParcel;
struct CFCFile;

extern CFCParser *CFCParser_current_state;
extern void      *CFCParser_current_parser;

CFCParser*
CFCParser_new(void);

CFCParser*
CFCParser_init(CFCParser *self);

void
CFCParser_destroy(CFCParser *self);

struct CFCBase*
CFCParser_parse(CFCParser *self, const char *string);

struct CFCFile*
CFCParser_parse_file(CFCParser *self, const char *string,
                     const char *source_class);

char*
CFCParser_dupe(CFCParser *self, const char *string);

void*
CFCParser_allocate(CFCParser *self, size_t size);

void
CFCParser_set_result(CFCParser *self, struct CFCBase *result);

void
CFCParser_set_errors(CFCParser *self, int errors);

void
CFCParser_set_text(CFCParser *self, const char *text, size_t len);

const char*
CFCParser_get_text(CFCParser *self);

void
CFCParser_set_parcel(struct CFCParcel *parcel);

struct CFCParcel*
CFCParser_get_parcel(void);

void
CFCParser_set_class_name(CFCParser *self, const char *class_name);

const char*
CFCParser_get_class_name(CFCParser *self);

void
CFCParser_set_class_cnick(CFCParser *self, const char *class_cnick);

const char*
CFCParser_get_class_cnick(CFCParser *self);

void
CFCParser_set_source_class(CFCParser *self, const char *source_class);

const char*
CFCParser_get_source_class(CFCParser *self);

#ifdef __cplusplus
}
#endif

#endif /* H_CFCPARSER */

