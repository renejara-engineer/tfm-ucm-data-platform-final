\set ON_ERROR_STOP on

-- Name: ix_fact_lic_fpub; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_lic_fpub ON dw.fact_licitaciones USING btree (fecha_publicacion_sk);


--

-- Name: ix_fact_lic_org; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_lic_org ON dw.fact_licitaciones USING btree (organismo_sk);


--

-- Name: ix_fact_lic_periodo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_lic_periodo ON dw.fact_licitaciones USING btree (periodo);


--

-- Name: ix_fact_lic_prod; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_lic_prod ON dw.fact_licitaciones USING btree (producto_onu_sk);


--

-- Name: ix_fact_lic_prov; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_lic_prov ON dw.fact_licitaciones USING btree (proveedor_sk);


--

-- Name: ix_fact_oc_fcrea; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_oc_fcrea ON dw.fact_ordenes_compra USING btree (fecha_creacion_sk);


--

-- Name: ix_fact_oc_org; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_oc_org ON dw.fact_ordenes_compra USING btree (organismo_sk);


--

-- Name: ix_fact_oc_periodo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_oc_periodo ON dw.fact_ordenes_compra USING btree (periodo);


--

-- Name: ix_fact_oc_prod; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_oc_prod ON dw.fact_ordenes_compra USING btree (producto_onu_sk);


--

-- Name: ix_fact_oc_prov; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE INDEX ix_fact_oc_prov ON dw.fact_ordenes_compra USING btree (proveedor_sk);


--

-- Name: ux_dim_fecha_fecha; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE UNIQUE INDEX ux_dim_fecha_fecha ON dw.dim_fecha USING btree (fecha);


--

-- Name: ux_dim_organismo_codigo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE UNIQUE INDEX ux_dim_organismo_codigo ON dw.dim_organismo USING btree (codigo_organismo);


--

-- Name: ux_dim_producto_onu_codigo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE UNIQUE INDEX ux_dim_producto_onu_codigo ON dw.dim_producto_onu USING btree (codigo_producto_onu);


--

-- Name: ux_dim_proveedor_codigo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE UNIQUE INDEX ux_dim_proveedor_codigo ON dw.dim_proveedor USING btree (codigo_proveedor);


--

-- Name: ux_fact_lic_bk_periodo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE UNIQUE INDEX ux_fact_lic_bk_periodo ON dw.fact_licitaciones USING btree (licitacion_bk, periodo);


--

-- Name: ux_fact_oc_bk_periodo; Type: INDEX; Schema: dw; Owner: chile_user
--

CREATE UNIQUE INDEX ux_fact_oc_bk_periodo ON dw.fact_ordenes_compra USING btree (orden_compra_bk, periodo);


--