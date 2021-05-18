library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrixPkg.all;

entity conv8_v1_0_S00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH : INTEGER := 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH : INTEGER := 9
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK    : in STD_LOGIC;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN : in STD_LOGIC;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR  : in STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH - 1 downto 0);
		-- Write channel Protection type. This signal indicates the
		-- privilege and security level of the transaction, and whether
		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT  : in STD_LOGIC_VECTOR(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
		-- valid write address and control information.
		S_AXI_AWVALID : in STD_LOGIC;
		-- Write address ready. This signal indicates that the slave is ready
		-- to accept an address and associated control signals.
		S_AXI_AWREADY : out STD_LOGIC;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA   : in STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
		-- valid data. There is one write strobe bit for each eight
		-- bits of the write data bus.    
		S_AXI_WSTRB   : in STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
		-- Write valid. This signal indicates that valid write
		-- data and strobes are available.
		S_AXI_WVALID  : in STD_LOGIC;
		-- Write ready. This signal indicates that the slave
		-- can accept the write data.
		S_AXI_WREADY  : out STD_LOGIC;
		-- Write response. This signal indicates the status
		-- of the write transaction.
		S_AXI_BRESP   : out STD_LOGIC_VECTOR(1 downto 0);
		-- Write response valid. This signal indicates that the channel
		-- is signaling a valid write response.
		S_AXI_BVALID  : out STD_LOGIC;
		-- Response ready. This signal indicates that the master
		-- can accept a write response.
		S_AXI_BREADY  : in STD_LOGIC;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR  : in STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH - 1 downto 0);
		-- Protection type. This signal indicates the privilege
		-- and security level of the transaction, and whether the
		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT  : in STD_LOGIC_VECTOR(2 downto 0);
		-- Read address valid. This signal indicates that the channel
		-- is signaling valid read address and control information.
		S_AXI_ARVALID : in STD_LOGIC;
		-- Read address ready. This signal indicates that the slave is
		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY : out STD_LOGIC;
		-- Read data (issued by slave)
		S_AXI_RDATA   : out STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
		-- Read response. This signal indicates the status of the
		-- read transfer.
		S_AXI_RRESP   : out STD_LOGIC_VECTOR(1 downto 0);
		-- Read valid. This signal indicates that the channel is
		-- signaling the required read data.
		S_AXI_RVALID  : out STD_LOGIC;
		-- Read ready. This signal indicates that the master can
		-- accept the read data and response information.
		S_AXI_RREADY  : in STD_LOGIC
	);
end conv8_v1_0_S00_AXI;

architecture arch_imp of conv8_v1_0_S00_AXI is

	-- AXI4LITE signals
	signal axi_awaddr          : STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH - 1 downto 0);
	signal axi_awready         : STD_LOGIC;
	signal axi_wready          : STD_LOGIC;
	signal axi_bresp           : STD_LOGIC_VECTOR(1 downto 0);
	signal axi_bvalid          : STD_LOGIC;
	signal axi_araddr          : STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH - 1 downto 0);
	signal axi_arready         : STD_LOGIC;
	signal axi_rdata           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal axi_rresp           : STD_LOGIC_VECTOR(1 downto 0);
	signal axi_rvalid          : STD_LOGIC;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB          : INTEGER := (C_S_AXI_DATA_WIDTH/32) + 1;
	constant OPT_MEM_ADDR_BITS : INTEGER := 6;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 101
	signal slv_reg0            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg1            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg2            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg3            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg4            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg5            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg6            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg7            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg8            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg9            : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg10           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg11           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg12           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg13           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg14           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg15           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg16           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg17           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg18           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg19           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg20           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg21           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg22           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg23           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg24           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg25           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg26           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg27           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg28           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg29           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg30           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg31           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg32           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg33           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg34           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg35           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg36           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg37           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg38           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg39           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg40           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg41           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg42           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg43           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg44           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg45           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg46           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg47           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg48           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg49           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg50           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg51           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg52           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg53           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg54           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg55           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg56           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg57           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg58           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg59           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg60           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg61           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg62           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg63           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg64           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg65           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg66           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg67           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg68           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg69           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg70           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg71           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg72           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg73           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg74           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg75           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg76           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg77           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg78           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg79           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg80           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg81           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg82           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg83           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg84           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg85           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg86           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg87           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg88           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg89           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg90           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg91           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg92           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg93           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg94           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg95           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg96           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg97           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg98           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg99           : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg100          : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal slv_reg_rden        : STD_LOGIC;
	signal slv_reg_wren        : STD_LOGIC;
	signal reg_data_out        : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 downto 0);
	signal byte_index          : INTEGER;
	signal aw_en               : STD_LOGIC;

	component nConv_padding
		generic (
			n : INTEGER; --width/length of input matrix
			k : INTEGER);--number of filters
		port (
			A     : in matrix(0 to n - 1, 0 to n - 1); --n*n*16bits input
			B     : in matrix(0 to 2, 0 to 2);         -- 3*3*16bits * k filters
			clk   : in STD_LOGIC;
			reset : in STD_LOGIC;
			start : in STD_LOGIC;
			done  : out STD_LOGIC;
			C     : out result(0 to n - 1, 0 to n - 1)); --n*n*32bits output
	end component;

	signal A       : matrix(0 to 7, 0 to 7);
	signal B       : matrix(0 to 2, 0 to 2);
	signal control : STD_LOGIC_VECTOR(15 downto 0);
	signal C       : result(0 to 7, 0 to 7);

begin
	-- I/O Connections assignments

	S_AXI_AWREADY <= axi_awready;
	S_AXI_WREADY  <= axi_wready;
	S_AXI_BRESP   <= axi_bresp;
	S_AXI_BVALID  <= axi_bvalid;
	S_AXI_ARREADY <= axi_arready;
	S_AXI_RDATA   <= axi_rdata;
	S_AXI_RRESP   <= axi_rresp;
	S_AXI_RVALID  <= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				axi_awready <= '0';
				aw_en       <= '1';
			else
				if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
					-- slave is ready to accept write address when
					-- there is a valid write address and write data
					-- on the write address and data bus. This design 
					-- expects no outstanding transactions. 
					axi_awready <= '1';
					aw_en       <= '0';
				elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
					aw_en       <= '1';
					axi_awready <= '0';
				else
					axi_awready <= '0';
				end if;
			end if;
		end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				axi_awaddr <= (others => '0');
			else
				if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
					-- Write Address latching
					axi_awaddr <= S_AXI_AWADDR;
				end if;
			end if;
		end if;
	end process;

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				axi_wready <= '0';
			else
				if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
					-- slave is ready to accept write data when 
					-- there is a valid write address and write data
					-- on the write address and data bus. This design 
					-- expects no outstanding transactions.           
					axi_wready <= '1';
				else
					axi_wready <= '0';
				end if;
			end if;
		end if;
	end process;

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID;

	process (S_AXI_ACLK)
		variable loc_addr : STD_LOGIC_VECTOR(OPT_MEM_ADDR_BITS downto 0);
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				slv_reg0   <= (others => '0');
				slv_reg1   <= (others => '0');
				slv_reg2   <= (others => '0');
				slv_reg3   <= (others => '0');
				slv_reg4   <= (others => '0');
				slv_reg5   <= (others => '0');
				slv_reg6   <= (others => '0');
				slv_reg7   <= (others => '0');
				slv_reg8   <= (others => '0');
				slv_reg9   <= (others => '0');
				slv_reg10  <= (others => '0');
				slv_reg11  <= (others => '0');
				slv_reg12  <= (others => '0');
				slv_reg13  <= (others => '0');
				slv_reg14  <= (others => '0');
				slv_reg15  <= (others => '0');
				slv_reg16  <= (others => '0');
				slv_reg17  <= (others => '0');
				slv_reg18  <= (others => '0');
				slv_reg19  <= (others => '0');
				slv_reg20  <= (others => '0');
				slv_reg21  <= (others => '0');
				slv_reg22  <= (others => '0');
				slv_reg23  <= (others => '0');
				slv_reg24  <= (others => '0');
				slv_reg25  <= (others => '0');
				slv_reg26  <= (others => '0');
				slv_reg27  <= (others => '0');
				slv_reg28  <= (others => '0');
				slv_reg29  <= (others => '0');
				slv_reg30  <= (others => '0');
				slv_reg31  <= (others => '0');
				slv_reg32  <= (others => '0');
				slv_reg33  <= (others => '0');
				slv_reg34  <= (others => '0');
				slv_reg35  <= (others => '0');
				slv_reg36  <= (others => '0');
				slv_reg37  <= (others => '0');
				slv_reg38  <= (others => '0');
				slv_reg39  <= (others => '0');
				slv_reg40  <= (others => '0');
				slv_reg41  <= (others => '0');
				slv_reg42  <= (others => '0');
				slv_reg43  <= (others => '0');
				slv_reg44  <= (others => '0');
				slv_reg45  <= (others => '0');
				slv_reg46  <= (others => '0');
				slv_reg47  <= (others => '0');
				slv_reg48  <= (others => '0');
				slv_reg49  <= (others => '0');
				slv_reg50  <= (others => '0');
				slv_reg51  <= (others => '0');
				slv_reg52  <= (others => '0');
				slv_reg53  <= (others => '0');
				slv_reg54  <= (others => '0');
				slv_reg55  <= (others => '0');
				slv_reg56  <= (others => '0');
				slv_reg57  <= (others => '0');
				slv_reg58  <= (others => '0');
				slv_reg59  <= (others => '0');
				slv_reg60  <= (others => '0');
				slv_reg61  <= (others => '0');
				slv_reg62  <= (others => '0');
				slv_reg63  <= (others => '0');
				slv_reg64  <= (others => '0');
				slv_reg65  <= (others => '0');
				slv_reg66  <= (others => '0');
				slv_reg67  <= (others => '0');
				slv_reg68  <= (others => '0');
				slv_reg69  <= (others => '0');
				slv_reg70  <= (others => '0');
				slv_reg71  <= (others => '0');
				slv_reg72  <= (others => '0');
				slv_reg73  <= (others => '0');
				slv_reg74  <= (others => '0');
				slv_reg75  <= (others => '0');
				slv_reg76  <= (others => '0');
				slv_reg77  <= (others => '0');
				slv_reg78  <= (others => '0');
				slv_reg79  <= (others => '0');
				slv_reg80  <= (others => '0');
				slv_reg81  <= (others => '0');
				slv_reg82  <= (others => '0');
				slv_reg83  <= (others => '0');
				slv_reg84  <= (others => '0');
				slv_reg85  <= (others => '0');
				slv_reg86  <= (others => '0');
				slv_reg87  <= (others => '0');
				slv_reg88  <= (others => '0');
				slv_reg89  <= (others => '0');
				slv_reg90  <= (others => '0');
				slv_reg91  <= (others => '0');
				slv_reg92  <= (others => '0');
				slv_reg93  <= (others => '0');
				slv_reg94  <= (others => '0');
				slv_reg95  <= (others => '0');
				slv_reg96  <= (others => '0');
				slv_reg97  <= (others => '0');
				slv_reg98  <= (others => '0');
				slv_reg99  <= (others => '0');
				slv_reg100 <= (others => '0');
			else
				loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
				if (slv_reg_wren = '1') then
					case loc_addr is
						when b"0000000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 0
									slv_reg0(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 1
									slv_reg1(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 2
									slv_reg2(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 3
									slv_reg3(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 4
									slv_reg4(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 5
									slv_reg5(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 6
									slv_reg6(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0000111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 7
									slv_reg7(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 8
									slv_reg8(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 9
									slv_reg9(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 10
									slv_reg10(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 11
									slv_reg11(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 12
									slv_reg12(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 13
									slv_reg13(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 14
									slv_reg14(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0001111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 15
									slv_reg15(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 16
									slv_reg16(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 17
									slv_reg17(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 18
									slv_reg18(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 19
									slv_reg19(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 20
									slv_reg20(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 21
									slv_reg21(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 22
									slv_reg22(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0010111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 23
									slv_reg23(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 24
									slv_reg24(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 25
									slv_reg25(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 26
									slv_reg26(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 27
									slv_reg27(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 28
									slv_reg28(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 29
									slv_reg29(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 30
									slv_reg30(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 31
									slv_reg31(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 32
									slv_reg32(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 33
									slv_reg33(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 34
									slv_reg34(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 35
									slv_reg35(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 36
									slv_reg36(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 37
									slv_reg37(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 38
									slv_reg38(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 39
									slv_reg39(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 40
									slv_reg40(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 41
									slv_reg41(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 42
									slv_reg42(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 43
									slv_reg43(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 44
									slv_reg44(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 45
									slv_reg45(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 46
									slv_reg46(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 47
									slv_reg47(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 48
									slv_reg48(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 49
									slv_reg49(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 50
									slv_reg50(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 51
									slv_reg51(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 52
									slv_reg52(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 53
									slv_reg53(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 54
									slv_reg54(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 55
									slv_reg55(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 56
									slv_reg56(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 57
									slv_reg57(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 58
									slv_reg58(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 59
									slv_reg59(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 60
									slv_reg60(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 61
									slv_reg61(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 62
									slv_reg62(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 63
									slv_reg63(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 64
									slv_reg64(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 65
									slv_reg65(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 66
									slv_reg66(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 67
									slv_reg67(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 68
									slv_reg68(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 69
									slv_reg69(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 70
									slv_reg70(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 71
									slv_reg71(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 72
									slv_reg72(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 73
									slv_reg73(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 74
									slv_reg74(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 75
									slv_reg75(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 76
									slv_reg76(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 77
									slv_reg77(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 78
									slv_reg78(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 79
									slv_reg79(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 80
									slv_reg80(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 81
									slv_reg81(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 82
									slv_reg82(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 83
									slv_reg83(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 84
									slv_reg84(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 85
									slv_reg85(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 86
									slv_reg86(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 87
									slv_reg87(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 88
									slv_reg88(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 89
									slv_reg89(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 90
									slv_reg90(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 91
									slv_reg91(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 92
									slv_reg92(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 93
									slv_reg93(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 94
									slv_reg94(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 95
									slv_reg95(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1100000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 96
									slv_reg96(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1100001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 97
									slv_reg97(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1100010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 98
									slv_reg98(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1100011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 99
									slv_reg99(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1100100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 100
									slv_reg100(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when others =>
							slv_reg0   <= slv_reg0;
							slv_reg1   <= slv_reg1;
							slv_reg2   <= slv_reg2;
							slv_reg3   <= slv_reg3;
							slv_reg4   <= slv_reg4;
							slv_reg5   <= slv_reg5;
							slv_reg6   <= slv_reg6;
							slv_reg7   <= slv_reg7;
							slv_reg8   <= slv_reg8;
							slv_reg9   <= slv_reg9;
							slv_reg10  <= slv_reg10;
							slv_reg11  <= slv_reg11;
							slv_reg12  <= slv_reg12;
							slv_reg13  <= slv_reg13;
							slv_reg14  <= slv_reg14;
							slv_reg15  <= slv_reg15;
							slv_reg16  <= slv_reg16;
							slv_reg17  <= slv_reg17;
							slv_reg18  <= slv_reg18;
							slv_reg19  <= slv_reg19;
							slv_reg20  <= slv_reg20;
							slv_reg21  <= slv_reg21;
							slv_reg22  <= slv_reg22;
							slv_reg23  <= slv_reg23;
							slv_reg24  <= slv_reg24;
							slv_reg25  <= slv_reg25;
							slv_reg26  <= slv_reg26;
							slv_reg27  <= slv_reg27;
							slv_reg28  <= slv_reg28;
							slv_reg29  <= slv_reg29;
							slv_reg30  <= slv_reg30;
							slv_reg31  <= slv_reg31;
							slv_reg32  <= slv_reg32;
							slv_reg33  <= slv_reg33;
							slv_reg34  <= slv_reg34;
							slv_reg35  <= slv_reg35;
							slv_reg36  <= slv_reg36;
							slv_reg37  <= slv_reg37;
							slv_reg38  <= slv_reg38;
							slv_reg39  <= slv_reg39;
							slv_reg40  <= slv_reg40;
							slv_reg41  <= slv_reg41;
							slv_reg42  <= slv_reg42;
							slv_reg43  <= slv_reg43;
							slv_reg44  <= slv_reg44;
							slv_reg45  <= slv_reg45;
							slv_reg46  <= slv_reg46;
							slv_reg47  <= slv_reg47;
							slv_reg48  <= slv_reg48;
							slv_reg49  <= slv_reg49;
							slv_reg50  <= slv_reg50;
							slv_reg51  <= slv_reg51;
							slv_reg52  <= slv_reg52;
							slv_reg53  <= slv_reg53;
							slv_reg54  <= slv_reg54;
							slv_reg55  <= slv_reg55;
							slv_reg56  <= slv_reg56;
							slv_reg57  <= slv_reg57;
							slv_reg58  <= slv_reg58;
							slv_reg59  <= slv_reg59;
							slv_reg60  <= slv_reg60;
							slv_reg61  <= slv_reg61;
							slv_reg62  <= slv_reg62;
							slv_reg63  <= slv_reg63;
							slv_reg64  <= slv_reg64;
							slv_reg65  <= slv_reg65;
							slv_reg66  <= slv_reg66;
							slv_reg67  <= slv_reg67;
							slv_reg68  <= slv_reg68;
							slv_reg69  <= slv_reg69;
							slv_reg70  <= slv_reg70;
							slv_reg71  <= slv_reg71;
							slv_reg72  <= slv_reg72;
							slv_reg73  <= slv_reg73;
							slv_reg74  <= slv_reg74;
							slv_reg75  <= slv_reg75;
							slv_reg76  <= slv_reg76;
							slv_reg77  <= slv_reg77;
							slv_reg78  <= slv_reg78;
							slv_reg79  <= slv_reg79;
							slv_reg80  <= slv_reg80;
							slv_reg81  <= slv_reg81;
							slv_reg82  <= slv_reg82;
							slv_reg83  <= slv_reg83;
							slv_reg84  <= slv_reg84;
							slv_reg85  <= slv_reg85;
							slv_reg86  <= slv_reg86;
							slv_reg87  <= slv_reg87;
							slv_reg88  <= slv_reg88;
							slv_reg89  <= slv_reg89;
							slv_reg90  <= slv_reg90;
							slv_reg91  <= slv_reg91;
							slv_reg92  <= slv_reg92;
							slv_reg93  <= slv_reg93;
							slv_reg94  <= slv_reg94;
							slv_reg95  <= slv_reg95;
							slv_reg96  <= slv_reg96;
							slv_reg97  <= slv_reg97;
							slv_reg98  <= slv_reg98;
							slv_reg99  <= slv_reg99;
							slv_reg100 <= slv_reg100;
					end case;
				end if;
			end if;
		end if;
	end process;

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				axi_bvalid <= '0';
				axi_bresp  <= "00"; --need to work more on the responses
			else
				if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0') then
					axi_bvalid <= '1';
					axi_bresp  <= "00";
				elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then --check if bready is asserted while bvalid is high)
					axi_bvalid <= '0';                                   -- (there is a possibility that bready is always asserted high)
				end if;
			end if;
		end if;
	end process;

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				axi_arready <= '0';
				axi_araddr  <= (others => '1');
			else
				if (axi_arready = '0' and S_AXI_ARVALID = '1') then
					-- indicates that the slave has acceped the valid read address
					axi_arready <= '1';
					-- Read Address latching 
					axi_araddr  <= S_AXI_ARADDR;
				else
					axi_arready <= '0';
				end if;
			end if;
		end if;
	end process;

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				axi_rvalid <= '0';
				axi_rresp  <= "00";
			else
				if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
					-- Valid read data is available at the read data bus
					axi_rvalid <= '1';
					axi_rresp  <= "00"; -- 'OKAY' response
				elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
					-- Read data is accepted by the master
					axi_rvalid <= '0';
				end if;
			end if;
		end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid);

	process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31, slv_reg32, slv_reg33, slv_reg34, slv_reg35, slv_reg36, slv_reg37, slv_reg38, slv_reg39, slv_reg40, slv_reg41, slv_reg42, slv_reg43, slv_reg44, slv_reg45, slv_reg46, slv_reg47, slv_reg48, slv_reg49, slv_reg50, slv_reg51, slv_reg52, slv_reg53, slv_reg54, slv_reg55, slv_reg56, slv_reg57, slv_reg58, slv_reg59, slv_reg60, slv_reg61, slv_reg62, slv_reg63, slv_reg64, slv_reg65, slv_reg66, slv_reg67, slv_reg68, slv_reg69, slv_reg70, slv_reg71, slv_reg72, slv_reg73, slv_reg74, slv_reg75, slv_reg76, slv_reg77, slv_reg78, slv_reg79, slv_reg80, slv_reg81, slv_reg82, slv_reg83, slv_reg84, slv_reg85, slv_reg86, slv_reg87, slv_reg88, slv_reg89, slv_reg90, slv_reg91, slv_reg92, slv_reg93, slv_reg94, slv_reg95, slv_reg96, slv_reg97, slv_reg98, slv_reg99, slv_reg100, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
		variable loc_addr : STD_LOGIC_VECTOR(OPT_MEM_ADDR_BITS downto 0);
	begin
		-- Address decoding for reading registers
		loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
		case loc_addr is
			when b"0000000" =>
				reg_data_out <= slv_reg0;
			when b"0000001" =>
				reg_data_out <= slv_reg1;
			when b"0000010" =>
				reg_data_out <= slv_reg2;
			when b"0000011" =>
				reg_data_out <= slv_reg3;
			when b"0000100" =>
				reg_data_out <= slv_reg4;
			when b"0000101" =>
				reg_data_out <= slv_reg5;
			when b"0000110" =>
				reg_data_out <= slv_reg6;
			when b"0000111" =>
				reg_data_out <= slv_reg7;
			when b"0001000" =>
				reg_data_out <= slv_reg8;
			when b"0001001" =>
				reg_data_out <= slv_reg9;
			when b"0001010" =>
				reg_data_out <= slv_reg10;
			when b"0001011" =>
				reg_data_out <= slv_reg11;
			when b"0001100" =>
				reg_data_out <= slv_reg12;
			when b"0001101" =>
				reg_data_out <= slv_reg13;
			when b"0001110" =>
				reg_data_out <= slv_reg14;
			when b"0001111" =>
				reg_data_out <= slv_reg15;
			when b"0010000" =>
				reg_data_out <= slv_reg16;
			when b"0010001" =>
				reg_data_out <= slv_reg17;
			when b"0010010" =>
				reg_data_out <= slv_reg18;
			when b"0010011" =>
				reg_data_out <= slv_reg19;
			when b"0010100" =>
				reg_data_out <= slv_reg20;
			when b"0010101" =>
				reg_data_out <= slv_reg21;
			when b"0010110" =>
				reg_data_out <= slv_reg22;
			when b"0010111" =>
				reg_data_out <= slv_reg23;
			when b"0011000" =>
				reg_data_out <= slv_reg24;
			when b"0011001" =>
				reg_data_out <= slv_reg25;
			when b"0011010" =>
				reg_data_out <= slv_reg26;
			when b"0011011" =>
				reg_data_out <= slv_reg27;
			when b"0011100" =>
				reg_data_out <= slv_reg28;
			when b"0011101" =>
				reg_data_out <= slv_reg29;
			when b"0011110" =>
				reg_data_out <= slv_reg30;
			when b"0011111" =>
				reg_data_out <= slv_reg31;
			when b"0100000" =>
				reg_data_out <= slv_reg32;
			when b"0100001" =>
				reg_data_out <= slv_reg33;
			when b"0100010" =>
				reg_data_out <= slv_reg34;
			when b"0100011" =>
				reg_data_out <= slv_reg35;
			when b"0100100" =>
				reg_data_out <= slv_reg36;
			when b"0100101" =>
				reg_data_out <= slv_reg37;
			when b"0100110" =>
				reg_data_out <= slv_reg38;
			when b"0100111" =>
				reg_data_out <= slv_reg39;
			when b"0101000" =>
				reg_data_out <= slv_reg40;
			when b"0101001" =>
				reg_data_out <= slv_reg41;
			when b"0101010" =>
				reg_data_out <= slv_reg42;
			when b"0101011" =>
				reg_data_out <= slv_reg43;
			when b"0101100" =>
				reg_data_out <= slv_reg44;
			when b"0101101" =>
				reg_data_out <= slv_reg45;
			when b"0101110" =>
				reg_data_out <= slv_reg46;
			when b"0101111" =>
				reg_data_out <= slv_reg47;
			when b"0110000" =>
				reg_data_out <= slv_reg48;
			when b"0110001" =>
				reg_data_out <= slv_reg49;
			when b"0110010" =>
				reg_data_out <= slv_reg50;
			when b"0110011" =>
				reg_data_out <= slv_reg51;
			when b"0110100" =>
				reg_data_out <= slv_reg52;
			when b"0110101" =>
				reg_data_out <= slv_reg53;
			when b"0110110" =>
				reg_data_out <= slv_reg54;
			when b"0110111" =>
				reg_data_out <= slv_reg55;
			when b"0111000" =>
				reg_data_out <= slv_reg56;
			when b"0111001" =>
				reg_data_out <= slv_reg57;
			when b"0111010" =>
				reg_data_out <= slv_reg58;
			when b"0111011" =>
				reg_data_out <= slv_reg59;
			when b"0111100" =>
				reg_data_out <= slv_reg60;
			when b"0111101" =>
				reg_data_out <= slv_reg61;
			when b"0111110" =>
				reg_data_out <= slv_reg62;
			when b"0111111" =>
				reg_data_out <= slv_reg63;
			when b"1000000" =>
				reg_data_out <= slv_reg64;
			when b"1000001" =>
				reg_data_out <= slv_reg65;
			when b"1000010" =>
				reg_data_out <= slv_reg66;
			when b"1000011" =>
				reg_data_out <= slv_reg67;
			when b"1000100" =>
				reg_data_out <= slv_reg68;
			when b"1000101" =>
				reg_data_out <= slv_reg69;
			when b"1000110" =>
				reg_data_out <= slv_reg70;
			when b"1000111" =>
				reg_data_out <= slv_reg71;
			when b"1001000" =>
				reg_data_out <= slv_reg72;
			when b"1001001" =>
				reg_data_out <= slv_reg73;
			when b"1001010" =>
				reg_data_out <= slv_reg74;
			when b"1001011" =>
				reg_data_out <= slv_reg75;
			when b"1001100" =>
				reg_data_out <= slv_reg76;
			when b"1001101" =>
				reg_data_out <= slv_reg77;
			when b"1001110" =>
				reg_data_out <= slv_reg78;
			when b"1001111" =>
				reg_data_out <= slv_reg79;
			when b"1010000" =>
				reg_data_out <= slv_reg80;
			when b"1010001" =>
				reg_data_out <= slv_reg81;
			when b"1010010" =>
				reg_data_out <= slv_reg82;
			when b"1010011" =>
				reg_data_out <= slv_reg83;
			when b"1010100" =>
				reg_data_out <= slv_reg84;
			when b"1010101" =>
				reg_data_out <= slv_reg85;
			when b"1010110" =>
				reg_data_out <= slv_reg86;
			when b"1010111" =>
				reg_data_out <= slv_reg87;
			when b"1011000" =>
				reg_data_out <= slv_reg88;
			when b"1011001" =>
				reg_data_out <= slv_reg89;
			when b"1011010" =>
				reg_data_out <= slv_reg90;
			when b"1011011" =>
				reg_data_out <= slv_reg91;
			when b"1011100" =>
				reg_data_out <= slv_reg92;
			when b"1011101" =>
				reg_data_out <= slv_reg93;
			when b"1011110" =>
				reg_data_out <= slv_reg94;
			when b"1011111" =>
				reg_data_out <= slv_reg95;
			when b"1100000" =>
				reg_data_out <= slv_reg96;
			when b"1100001" =>
				reg_data_out <= slv_reg97;
			when b"1100010" =>
				reg_data_out <= slv_reg98;
			when b"1100011" =>
				reg_data_out <= slv_reg99;
			when b"1100100" =>
				reg_data_out <= slv_reg100;
			when others             =>
				reg_data_out <= (others => '0');
		end case;
	end process;

	-- Output register or memory read data
	process (S_AXI_ACLK) is
	begin
		if (rising_edge (S_AXI_ACLK)) then
			if (S_AXI_ARESETN = '0') then
				axi_rdata <= (others => '0');
			else
				if (slv_reg_rden = '1') then
					-- When there is a valid read address (S_AXI_ARVALID) with 
					-- acceptance of read address by the slave (axi_arready), 
					-- output the read dada 
					-- Read address mux
					axi_rdata <= reg_data_out; -- register read data
				end if;
			end if;
		end if;
	end process;
	-- Add user logic here
	A(0, 0) <= slv_reg0(31 downto 16);
	A(0, 1) <= slv_reg0(15 downto 0);
	A(0, 2) <= slv_reg1(31 downto 16);
	A(0, 3) <= slv_reg1(15 downto 0);
	A(0, 4) <= slv_reg2(31 downto 16);
	A(0, 5) <= slv_reg2(15 downto 0);
	A(0, 6) <= slv_reg3(31 downto 16);
	A(0, 7) <= slv_reg3(15 downto 0);
	A(1, 0) <= slv_reg4(31 downto 16);
	A(1, 1) <= slv_reg4(15 downto 0);
	A(1, 2) <= slv_reg5(31 downto 16);
	A(1, 3) <= slv_reg5(15 downto 0);
	A(1, 4) <= slv_reg6(31 downto 16);
	A(1, 5) <= slv_reg6(15 downto 0);
	A(1, 6) <= slv_reg7(31 downto 16);
	A(1, 7) <= slv_reg7(15 downto 0);
	A(2, 0) <= slv_reg8(31 downto 16);
	A(2, 1) <= slv_reg8(15 downto 0);
	A(2, 2) <= slv_reg9(31 downto 16);
	A(2, 3) <= slv_reg9(15 downto 0);
	A(2, 4) <= slv_reg10(31 downto 16);
	A(2, 5) <= slv_reg10(15 downto 0);
	A(2, 6) <= slv_reg11(31 downto 16);
	A(2, 7) <= slv_reg11(15 downto 0);
	A(3, 0) <= slv_reg12(31 downto 16);
	A(3, 1) <= slv_reg12(15 downto 0);
	A(3, 2) <= slv_reg13(31 downto 16);
	A(3, 3) <= slv_reg13(15 downto 0);
	A(3, 4) <= slv_reg14(31 downto 16);
	A(3, 5) <= slv_reg14(15 downto 0);
	A(3, 6) <= slv_reg15(31 downto 16);
	A(3, 7) <= slv_reg15(15 downto 0);
	A(4, 0) <= slv_reg16(31 downto 16);
	A(4, 1) <= slv_reg16(15 downto 0);
	A(4, 2) <= slv_reg17(31 downto 16);
	A(4, 3) <= slv_reg17(15 downto 0);
	A(4, 4) <= slv_reg18(31 downto 16);
	A(4, 5) <= slv_reg18(15 downto 0);
	A(4, 6) <= slv_reg19(31 downto 16);
	A(4, 7) <= slv_reg19(15 downto 0);
	A(5, 0) <= slv_reg20(31 downto 16);
	A(5, 1) <= slv_reg20(15 downto 0);
	A(5, 2) <= slv_reg21(31 downto 16);
	A(5, 3) <= slv_reg21(15 downto 0);
	A(5, 4) <= slv_reg22(31 downto 16);
	A(5, 5) <= slv_reg22(15 downto 0);
	A(5, 6) <= slv_reg23(31 downto 16);
	A(5, 7) <= slv_reg23(15 downto 0);
	A(6, 0) <= slv_reg24(31 downto 16);
	A(6, 1) <= slv_reg24(15 downto 0);
	A(6, 2) <= slv_reg25(31 downto 16);
	A(6, 3) <= slv_reg25(15 downto 0);
	A(6, 4) <= slv_reg26(31 downto 16);
	A(6, 5) <= slv_reg26(15 downto 0);
	A(6, 6) <= slv_reg27(31 downto 16);
	A(6, 7) <= slv_reg27(15 downto 0);
	A(7, 0) <= slv_reg28(31 downto 16);
	A(7, 1) <= slv_reg28(15 downto 0);
	A(7, 2) <= slv_reg29(31 downto 16);
	A(7, 3) <= slv_reg29(15 downto 0);
	A(7, 4) <= slv_reg30(31 downto 16);
	A(7, 5) <= slv_reg30(15 downto 0);
	A(7, 6) <= slv_reg31(31 downto 16);
	A(7, 7) <= slv_reg31(15 downto 0);

	B(0, 0) <= slv_reg32(31 downto 16);
	B(0, 1) <= slv_reg32(15 downto 0);
	B(0, 2) <= slv_reg33(31 downto 16);
	B(1, 0) <= slv_reg33(15 downto 0);
	B(1, 1) <= slv_reg34(31 downto 16);
	B(1, 2) <= slv_reg34(15 downto 0);
	B(2, 0) <= slv_reg35(31 downto 16);
	B(2, 1) <= slv_reg35(15 downto 0);
	B(2, 2) <= slv_reg36(31 downto 16);

	control <= slv_reg36(15 downto 0);

	C(0, 0) <= slv_reg37;
	C(0, 1) <= slv_reg38;
	C(0, 2) <= slv_reg39;
	C(0, 3) <= slv_reg40;
	C(0, 4) <= slv_reg41;
	C(0, 5) <= slv_reg42;
	C(0, 6) <= slv_reg43;
	C(0, 7) <= slv_reg44;
	C(1, 0) <= slv_reg45;
	C(1, 1) <= slv_reg46;
	C(1, 2) <= slv_reg47;
	C(1, 3) <= slv_reg48;
	C(1, 4) <= slv_reg49;
	C(1, 5) <= slv_reg50;
	C(1, 6) <= slv_reg51;
	C(1, 7) <= slv_reg52;
	C(2, 0) <= slv_reg53;
	C(2, 1) <= slv_reg54;
	C(2, 2) <= slv_reg55;
	C(2, 3) <= slv_reg56;
	C(2, 4) <= slv_reg57;
	C(2, 5) <= slv_reg58;
	C(2, 6) <= slv_reg59;
	C(2, 7) <= slv_reg60;
	C(3, 0) <= slv_reg61;
	C(3, 1) <= slv_reg62;
	C(3, 2) <= slv_reg63;
	C(3, 3) <= slv_reg64;
	C(3, 4) <= slv_reg65;
	C(3, 5) <= slv_reg66;
	C(3, 6) <= slv_reg67;
	C(3, 7) <= slv_reg68;
	C(4, 0) <= slv_reg69;
	C(4, 1) <= slv_reg70;
	C(4, 2) <= slv_reg71;
	C(4, 3) <= slv_reg72;
	C(4, 4) <= slv_reg73;
	C(4, 5) <= slv_reg74;
	C(4, 6) <= slv_reg75;
	C(4, 7) <= slv_reg76;
	C(5, 0) <= slv_reg77;
	C(5, 1) <= slv_reg78;
	C(5, 2) <= slv_reg79;
	C(5, 3) <= slv_reg80;
	C(5, 4) <= slv_reg81;
	C(5, 5) <= slv_reg82;
	C(5, 6) <= slv_reg83;
	C(5, 7) <= slv_reg84;
	C(6, 0) <= slv_reg85;
	C(6, 1) <= slv_reg86;
	C(6, 2) <= slv_reg87;
	C(6, 3) <= slv_reg88;
	C(6, 4) <= slv_reg89;
	C(6, 5) <= slv_reg90;
	C(6, 6) <= slv_reg91;
	C(6, 7) <= slv_reg92;
	C(7, 0) <= slv_reg93;
	C(7, 1) <= slv_reg94;
	C(7, 2) <= slv_reg95;
	C(7, 3) <= slv_reg96;
	C(7, 4) <= slv_reg97;
	C(7, 5) <= slv_reg98;
	C(7, 6) <= slv_reg99;
	C(7, 7) <= slv_reg100;

	CONV0 : nConv_padding
	generic map(
		n => 8,
		k => 0
	)
	port map(
		A     => A,
		B     => B,
		clk   => S_AXI_ACLK,
		reset => control(2),
		start => control(1),
		done  => control(0),
		C     => C
	);
	-- User logic ends

end arch_imp;